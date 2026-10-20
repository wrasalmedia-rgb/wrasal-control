# frozen_string_literal: true
require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require_relative '../scripts/notion_work_queue_sync'

class NotionSyncTest < Minitest::Test
  Sync = WRASAL::NotionWorkQueue::Sync
  Client = WRASAL::NotionWorkQueue::NotionClient
  Blocked = WRASAL::NotionWorkQueue::Blocked

  class FakeClient
    attr_reader :creates, :updates
    def initialize(page = nil)
      @pages = page ? { page.fetch('id') => page } : {}
      @creates = @updates = 0
    end
    def find(id)
      matches = @pages.values.select { |p| p.dig('properties', 'Control Work Order ID', 'rich_text', 0, 'text', 'content') == id }
      raise Blocked, 'duplicate ID' if matches.size > 1
      matches.first
    end
    def get_page(id) = @pages.fetch(id)
    def create(properties)
      @creates += 1
      page = { 'id' => 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'properties' => JSON.parse(JSON.generate(properties)) }
      @pages[page['id']] = page
      page
    end
    def update(id, properties)
      @updates += 1
      @pages.fetch(id)['properties'].merge!(JSON.parse(JSON.generate(properties)))
      @pages.fetch(id)
    end
  end

  def sample_order
    {
      'work_order_id' => 'WRASAL-0005', 'project' => 'WRASAL',
      'objective' => 'Validate a control plane', 'record_authority' => 'WRASAL-0005',
      'recorded_on' => '2026-10-03', 'execution_status' => 'passed',
      'implementation_result' => 'pass', 'verification_result' => 'pass',
      'canonical_acceptance' => 'pending', 'references' => { 'canonical_acceptance_record' => nil },
      'evidence' => [{ 'source' => 'test fixture' }]
    }
  end

  def with_repo(order = sample_order)
    Dir.mktmpdir('wrasal-sync-') do |dir|
      FileUtils.mkdir_p(File.join(dir, 'work_orders'))
      File.write(File.join(dir, 'work_orders/WRASAL-0005.json'), JSON.generate(order))
      run_git(dir, 'init', '-q')
      run_git(dir, 'add', '.')
      run_git(dir, '-c', 'user.name=Test', '-c', 'user.email=test@example.org', 'commit', '-qm', 'fixture')
      yield dir
    end
  end

  def run_git(dir, *args)
    assert system('git', '-C', dir, *args, out: File::NULL, err: File::NULL)
  end

  def fake_page(record)
    props = Sync.allocate.send(:to_notion_properties, record.fetch('properties'))
    { 'id' => 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'properties' => JSON.parse(JSON.generate(props)) }
  end

  def test_dry_run_is_offline_and_no_authority_promotion
    with_repo do |dir|
      result = Sync.new(root: dir).run
      assert_equal 'DRY RUN', result[:mode]
      assert_equal 1, result[:count]
      props = result[:projected].first.fetch('properties')
      assert_equal 'In progress', props['Status']
      assert_equal 'pending', props['Control Acceptance']
      assert_equal 'PARTIAL', props['Evidence Status']
      assert_equal 'AUTOMATED READ ONLY', props['Projection Mode']
      assert_match(/\A[0-9a-f]{40}\z/, props['Source Revision'])
    end
  end

  def test_idempotent_create_and_read_back
    with_repo do |dir|
      c = FakeClient.new
      adapter = Sync.new(root: dir, client: c)
      assert_equal 'created', adapter.run(mode: :apply)[:results].first[:result]
      assert_equal 'unchanged', adapter.run(mode: :apply)[:results].first[:result]
      assert_equal 1, c.creates
      assert_equal 0, c.updates
    end
  end

  def test_new_source_revision_updates_only_the_mirror
    with_repo do |dir|
      base = Sync.new(root: dir).projected_records.first
      base['properties']['Source Revision'] = 'b' * 40
      c = FakeClient.new(fake_page(base))
      assert_equal 'updated', Sync.new(root: dir, client: c).run(mode: :apply)[:results].first[:result]
      assert_equal 1, c.updates
    end
  end

  def test_same_revision_drift_and_wrong_record_class_blocked
    with_repo do |dir|
      record = Sync.new(root: dir).projected_records.first
      page = fake_page(record)
      page['properties']['Status'] = { 'status' => { 'name' => 'Done' } }
      c = FakeClient.new(page)
      assert_raises(Blocked) { Sync.new(root: dir, client: c).run(mode: :apply) }
      assert_equal 0, c.updates
      page['properties']['Status'] = { 'status' => { 'name' => 'In progress' } }
      page['properties']['Record Class'] = { 'select' => { 'name' => 'WRASAL CANDIDATE' } }
      assert_raises(Blocked) { Sync.new(root: dir, client: c).run(mode: :apply) }
    end
  end

  def test_bad_source_is_rejected_before_write
    with_repo(sample_order.merge('execution_status' => 'DONE')) do |dir|
      c = FakeClient.new
      assert_raises(Blocked) { Sync.new(root: dir, client: c).run(mode: :apply) }
      assert_equal 0, c.creates
    end
  end

  def test_manual_adoption_requires_explicit_opt_in_and_no_drift
    with_repo do |dir|
      record = Sync.new(root: dir).projected_records.first
      page = fake_page(record)
      url = record['properties']['Control Record URL']
      page['properties']['Control Record URL'] = { 'url' => url.sub(%r{/blob/[0-9a-f]{40}/}, '/blob/main/') }
      page['properties']['Projection Mode'] = { 'select' => { 'name' => 'READ ONLY SNAPSHOT' } }
      c = FakeClient.new(page)
      assert_raises(Blocked) { Sync.new(root: dir, client: c).run(mode: :apply) }
      assert_equal 'updated', Sync.new(root: dir, client: c, adopt_manual: true).run(mode: :apply)[:results].first[:result]
      assert_equal 1, c.updates
    end
  end

  def test_unsafe_manual_adoption_fails_closed
    with_repo do |dir|
      record = Sync.new(root: dir).projected_records.first
      page = fake_page(record)
      page['properties']['Projection Mode'] = { 'select' => { 'name' => 'READ ONLY SNAPSHOT' } }
      page['properties']['Status'] = { 'status' => { 'name' => 'Done' } }
      c = FakeClient.new(page)
      assert_raises(Blocked) { Sync.new(root: dir, client: c, adopt_manual: true).run(mode: :apply) }
      assert_equal 0, c.updates
    end
  end

  def test_destination_allowlist_and_write_retry_policy
    assert_raises(Blocked) { Client.new(token: 'redacted', data_source_id: 'another') }
    attempts = 0
    c = Client.new(token: 'redacted', data_source_id: 'bb6c034c-1032-8388-b290-871e298c82dd',
                   transport: ->(_method, _path, _body) { attempts += 1; { code: 429, body: '{}' } })
    assert_raises(Blocked) { c.create({}) }
    assert_equal 1, attempts
  end
end
