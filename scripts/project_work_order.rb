# frozen_string_literal: true

# S2 projection only: never submit workflow transitions or approve releases.
require 'json'
require 'optparse'

module WRASAL
  module WorkOrderProjection
    class InvalidSource < StandardError; end

    STATUSES = %w[requested executing blocked passed failed].freeze
    RESULTS = %w[unknown pass fail blocked].freeze
    ACCEPTANCE = %w[pending accepted].freeze
    URL = %r{\Ahttps://github\.com/wrasalmedia-rgb/wrasal-control/blob/[a-zA-Z0-9._/-]+/work_orders/(WRASAL-\d{4})\.json\z}.freeze

    module_function

    def project(document:, source_url:, revision:)
      raise InvalidSource, 'source must be a JSON object' unless document.is_a?(Hash)
      match = URL.match(source_url.to_s)
      raise InvalidSource, 'source URL outside approved control repository' unless match
      raise InvalidSource, 'revision must be a 40-digit hex Git blob SHA' unless /\A[0-9a-f]{40}\z/.match?(revision.to_s)

      identifier = document['work_order_id']
      raise InvalidSource, 'work order ID mismatches source URL' unless identifier == match[1]
      %w[objective project recorded_on record_authority].each do |key|
        raise InvalidSource, "missing #{key}" unless populated?(document[key])
      end
      raise InvalidSource, 'invalid recorded_on' unless /\A\d{4}-\d{2}-\d{2}\z/.match?(document['recorded_on'])
      check_enum(document, 'execution_status', STATUSES)
      check_enum(document, 'implementation_result', RESULTS)
      check_enum(document, 'verification_result', RESULTS)
      check_enum(document, 'canonical_acceptance', ACCEPTANCE)
      raise InvalidSource, 'references must be an object' unless document['references'].is_a?(Hash)
      raise InvalidSource, 'evidence must be an array' unless document['evidence'].is_a?(Array)

      # Fail closed: do not infer verified human approval from a source field.
      # This projector NEVER marks an item Done.
      status = document['execution_status'] == 'requested' ? 'Not started' : 'In progress'
      evidence = document['verification_result'] == 'pass' ? 'PARTIAL' : 'UNVERIFIED'
      gate = document['verification_result'] == 'pass' ? 'REVIEW' : 'VERIFY'
      gate = 'SCOPE' if document['execution_status'] == 'requested'

      {
        'properties' => {
          'Project Name' => "#{identifier} · #{document['objective']}",
          'Status' => status,
          'Record Class' => 'LIVE MIRROR',
          'Control Work Order ID' => identifier,
          'Control Record URL' => source_url,
          'Control Execution' => document['execution_status'],
          'Control Acceptance' => document['canonical_acceptance'],
          'Control Implementation' => document['implementation_result'],
          'Control Verification' => document['verification_result'],
          'Control Authority' => document['record_authority'],
          'Source Revision' => revision,
          'Projection Mode' => 'READ ONLY SNAPSHOT',
          'Evidence Status' => evidence,
          'Delivery Gate' => gate
        },
        'source' => { 'url' => source_url, 'blob_sha' => revision },
        'warning' => 'A Notion mirror is not Work Control authority, runtime verification, or release approval.'
      }
    end

    def populated?(value)
      value.is_a?(String) && !value.strip.empty?
    end

    def check_enum(document, key, allowed)
      return if allowed.include?(document[key])
      raise InvalidSource, "invalid #{key}"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  options = {}
  parser = OptionParser.new do |p|
    p.banner = 'Usage: ruby scripts/project_work_order.rb --file PATH --url GITHUB_BLOB_URL --revision GIT_BLOB_SHA'
    p.on('--file PATH') { |v| options[:file] = v }
    p.on('--url URL') { |v| options[:url] = v }
    p.on('--revision SHA') { |v| options[:revision] = v }
  end
  begin
    parser.parse!
    raise WRASAL::WorkOrderProjection::InvalidSource, 'all three inputs are required' unless
      %i[file url revision].all? { |k| options[k].is_a?(String) && !options[k].empty? }
    document = JSON.parse(File.read(options[:file], encoding: 'UTF-8'))
    puts JSON.pretty_generate(WRASAL::WorkOrderProjection.project(
      document: document, source_url: options[:url], revision: options[:revision]
    ))
  rescue WRASAL::WorkOrderProjection::InvalidSource, JSON::ParserError, Errno::ENOENT => e
    warn "BLOCKED: #{e.message}"
    exit 1
  end
end
