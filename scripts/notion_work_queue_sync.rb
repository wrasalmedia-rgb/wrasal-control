# frozen_string_literal: true

# One-way, fail-closed projection. Neither Notion nor this code is a workflow authority.
require 'json'
require 'net/http'
require 'uri'
require 'optparse'
require 'open3'
require_relative 'project_work_order'

module WRASAL
  module NotionWorkQueue
    class Blocked < StandardError; end

    DATA_SOURCE_ID = 'bb6c034c-1032-8388-b290-871e298c82dd'
    REPOSITORY = 'wrasalmedia-rgb/wrasal-control'
    API_VERSION = '2025-09-03'
    MAX_RECORDS = 30

    # Allowlist of projection fields. No authority, payout or Canon changes.
    TITLE = ['Project Name'].freeze
    TEXT = ['Control Work Order ID', 'Control Execution', 'Control Implementation',
            'Control Verification', 'Control Authority', 'Source Revision'].freeze
    SELECT = ['Record Class', 'Control Acceptance', 'Projection Mode',
              'Evidence Status', 'Delivery Gate'].freeze
    STATUS = ['Status'].freeze
    URL = ['Control Record URL'].freeze
    WRITE_KEYS = (TITLE + TEXT + SELECT + STATUS + URL).freeze

    class NotionClient
      def initialize(token:, data_source_id:, transport: nil)
        raise Blocked, 'Notion token is missing' if token.to_s.empty?
        raise Blocked, 'Invalid target data source' unless data_source_id == DATA_SOURCE_ID

        @token, @transport = token, transport
        @root = URI('https://api.notion.com')
        @source_id = data_source_id
      end

      def find(work_id)
        body = { filter: { property: 'Control Work Order ID', rich_text: { equals: work_id } },
                 page_size: 100 }
        response = request('POST', "/v1/data_sources/#{@source_id}/query", body, safe_retry: true)
        raise Blocked, 'Notion query pagination unexpected: HOLD for manual reconciliation' if response['has_more']
        pages = response.fetch('results')
        raise Blocked, "Duplicate Notion mirror ID #{work_id}" if pages.size > 1
        pages.first
      end

      def get_page(id)
        request('GET', "/v1/pages/#{validate_uuid(id)}", nil, safe_retry: true)
      end

      def create(properties)
        request('POST', '/v1/pages',
                { parent: { type: 'data_source_id', data_source_id: @source_id },
                  properties: properties }, safe_retry: false)
      end

      def update(id, properties)
        request('PATCH', "/v1/pages/#{validate_uuid(id)}",
                { properties: properties }, safe_retry: false)
      end

      private

      def validate_uuid(value)
        raise Blocked, 'Malformed Notion page ID' unless value.to_s.match?(/\A[0-9a-f-]{32,36}\z/i)
        value
      end

      def request(method, path, body, safe_retry:)
        attempts = 0
        loop do
          attempts += 1
          response = @transport ? @transport.call(method, path, body) : http_request(method, path, body)
          raise Blocked, 'Unexpected Notion response' unless response.is_a?(Hash) && response.key?(:code)
          code = response[:code].to_i
          if code == 429 && safe_retry && attempts < 4
            sleep([[response.fetch(:retry_after, 1).to_i, 1].max, 4].min)
            next
          end
          # Do not log response bodies: they may contain workspace or customer data.
          raise Blocked, "Notion HTTP #{code}; no further writes attempted" unless code.between?(200, 299)
          begin
            return response[:body].is_a?(Hash) ? response[:body] : JSON.parse(response.fetch(:body))
          rescue JSON::ParserError
            raise Blocked, 'Malformed Notion response; HOLD for reconciliation'
          end
        end
      end

      def http_request(method, path, body)
        uri = @root + path
        req = case method
              when 'POST' then Net::HTTP::Post.new(uri)
              when 'PATCH' then Net::HTTP::Patch.new(uri)
              when 'GET' then Net::HTTP::Get.new(uri)
              else raise Blocked, 'Unsupported HTTP method'
              end
        req['Authorization'] = "Bearer #{@token}"
        req['Notion-Version'] = API_VERSION
        req['Content-Type'] = 'application/json'
        req.body = JSON.generate(body) unless body.nil?
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 12) { |http| http.request(req) }
        { code: res.code.to_i, body: res.body, retry_after: res['Retry-After'] }
      rescue StandardError => e
        raise Blocked, "Notion transport uncertain (#{e.class}); HOLD for reconciliation"
      end
    end

    class Sync
      def initialize(root:, client: nil, commit: nil, adopt_manual: false)
        @root = File.realpath(root)
        @client = client
        @adopt_manual = adopt_manual
        @commit = commit || git('rev-parse', 'HEAD').strip
        raise Blocked, 'Invalid commit SHA' unless @commit.match?(/\A[0-9a-f]{40}\z/)
      end

      def source_files
        filenames = git('ls-files', '--', 'work_orders/WRASAL-*.json').lines.map(&:strip)
        files = filenames.select { |f| f.match?(%r{\Awork_orders/WRASAL-\d{4}\.json\z}) }.sort
        raise Blocked, 'No control source records found' if files.empty?
        raise Blocked, 'Too many source records for bounded sync' if files.size > MAX_RECORDS
        files
      end

      def projected_records
        source_files.map do |path|
          file_bytes = git('show', "#{@commit}:#{path}")
          revision = git('rev-parse', "#{@commit}:#{path}").strip
          raise Blocked, 'Invalid observed Git blob ID' unless revision.match?(/\A[0-9a-f]{40}\z/)
          doc = JSON.parse(file_bytes)
          url = "https://github.com/#{REPOSITORY}/blob/#{@commit}/#{path}"
          projected = WRASAL::WorkOrderProjection.project(document: doc, source_url: url, revision: revision)
          projected.fetch('properties')['Projection Mode'] = 'AUTOMATED READ ONLY'
          projected
        end
      rescue JSON::ParserError, WRASAL::WorkOrderProjection::InvalidSource => e
        raise Blocked, "Bad source work order: #{e.message}"
      end

      def run(mode: :dry_run)
        records = projected_records  # Validate all before any write.
        return { mode: 'DRY RUN', count: records.size, projected: records } if mode == :dry_run
        raise Blocked, 'Invalid sync mode' unless mode == :apply
        raise Blocked, 'Authenticated Notion client required' unless @client
        results = records.map { |record| apply_record(record) }
        { mode: 'APPLY', count: results.size, results: results }
      end

      def apply_record(record)
        props = record.fetch('properties')
        id = props.fetch('Control Work Order ID')
        existing = @client.find(id)
        target = to_notion_properties(props)
        if existing
          page_id = existing.fetch('id')
          fresh = @client.get_page(page_id)
          verify_source_identity!(fresh, id)
          return { id: id, result: 'unchanged', page_id: page_id } if property_values(fresh) == props
          if current_string(fresh, 'Source Revision') == props.fetch('Source Revision')
            raise Blocked, "Mirror drift for #{id}: same Git revision but Notion fields changed" unless
              @adopt_manual && safe_manual_adoption?(fresh, props)
          end
          @client.update(page_id, target)
          operation = 'updated'
        else
          created = @client.create(target) # Never retry ambiguous create.
          page_id = created.fetch('id')
          operation = 'created'
        end
        read_back = @client.get_page(page_id)
        verify_source_identity!(read_back, id)
        raise Blocked, "Post-write mismatch for #{id}" unless property_values(read_back) == props
        confirmed = @client.find(id)
        raise Blocked, "Cannot confirm unique mirror for #{id}" unless confirmed && confirmed['id'] == page_id
        { id: id, result: operation, page_id: page_id }
      end

      def verify_source_identity!(page, expected_id)
        raise Blocked, 'Missing Notion properties' unless page['properties'].is_a?(Hash)
        raise Blocked, "Mirror identity collision for #{expected_id}" unless
          current_string(page, 'Control Work Order ID') == expected_id
        raise Blocked, 'Target record not classified LIVE MIRROR' unless
          current_string(page, 'Record Class') == 'LIVE MIRROR'
      end

      def property_values(page)
        WRITE_KEYS.to_h { |key| [key, current_string(page, key)] }
      end

      def current_string(page, key)
        property = page.fetch('properties').fetch(key)
        if TITLE.include?(key)
          property.fetch('title').map { |x| x.fetch('plain_text', x.dig('text', 'content')) }.join
        elsif TEXT.include?(key)
          property.fetch('rich_text').map { |x| x.fetch('plain_text', x.dig('text', 'content')) }.join
        elsif SELECT.include?(key)
          property.dig('select', 'name')
        elsif STATUS.include?(key)
          property.dig('status', 'name')
        elsif URL.include?(key)
          property['url']
        else
          raise Blocked, "Unexpected field #{key}"
        end
      end

      # An existing manually observed snapshot may be upgraded exactly once
      # with explicit opt-in and no discrepancies in any other field.
      def safe_manual_adoption?(page, props)
        existing = property_values(page)
        return false unless existing['Projection Mode'] == 'READ ONLY SNAPSHOT'
        permitted = ['Projection Mode', 'Control Record URL']
        return false unless (WRITE_KEYS - permitted).all? { |k| existing[k] == props[k] }
        old_url = existing['Control Record URL'].to_s
        old_url == props['Control Record URL'].sub(%r{/blob/[0-9a-f]{40}/}, '/blob/main/')
      end

      def to_notion_properties(props)
        raise Blocked, 'Unknown projected field' unless (props.keys - WRITE_KEYS).empty?
        WRITE_KEYS.to_h do |key|
          value = props.fetch(key)
          raise Blocked, "Invalid value for #{key}" unless value.is_a?(String) && !value.empty? && value.length <= 2000
          notion_value = if TITLE.include?(key)
                           { title: [{ text: { content: value } }] }
                         elsif TEXT.include?(key)
                           { rich_text: [{ text: { content: value } }] }
                         elsif SELECT.include?(key)
                           { select: { name: value } }
                         elsif STATUS.include?(key)
                           { status: { name: value } }
                         elsif URL.include?(key)
                           { url: value }
                         end
          [key, notion_value]
        end
      end

      private

      def git(*args)
        out, err, status = Open3.capture3('git', '-C', @root, *args)
        raise Blocked, "Git source unavailable (#{args.first}): #{err[0, 180]}" unless status.success?
        out
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  opts = { mode: :dry_run, root: File.expand_path('..', __dir__), adopt_manual: false }
  OptionParser.new do |parser|
    parser.banner = 'Usage: ruby scripts/notion_work_queue_sync.rb [--root DIR] [--dry-run | --apply]'
    parser.on('--root ROOT') { |v| opts[:root] = v }
    parser.on('--dry-run') { opts[:mode] = :dry_run }
    parser.on('--apply') { opts[:mode] = :apply }
    parser.on('--adopt-verified-manual-snapshot') { opts[:adopt_manual] = true }
  end.parse!
  begin
    if opts[:mode] == :apply && ENV['WRASAL_NOTION_APPLY'] != 'EXPLICITLY_AUTHORIZED'
      raise WRASAL::NotionWorkQueue::Blocked, 'Notion write switch absent; default is DRY RUN'
    end
    client = if opts[:mode] == :apply
               WRASAL::NotionWorkQueue::NotionClient.new(
                 token: ENV['NOTION_API_TOKEN'], data_source_id: ENV.fetch('NOTION_DATA_SOURCE_ID', ''))
             end
    sync = WRASAL::NotionWorkQueue::Sync.new(root: opts[:root], client: client,
                                             adopt_manual: opts[:adopt_manual])
    puts JSON.pretty_generate(sync.run(mode: opts[:mode]))
  rescue WRASAL::NotionWorkQueue::Blocked => e
    warn "BLOCKED: #{e.message}"
    exit 1
  end
end
