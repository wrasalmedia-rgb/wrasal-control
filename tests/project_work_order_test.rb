# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../scripts/project_work_order'

class WorkOrderProjectionTest < Minitest::Test
  URL = 'https://github.com/wrasalmedia-rgb/wrasal-control/blob/main/work_orders/WRASAL-0005.json'
  REV = 'a' * 40

  def valid_order
    {
      'work_order_id' => 'WRASAL-0005',
      'objective' => 'Validate an S3 control-plane scaffold',
      'project' => 'WRASAL',
      'record_authority' => 'WRASAL-0005',
      'recorded_on' => '2026-10-03',
      'execution_status' => 'passed',
      'implementation_result' => 'pass',
      'verification_result' => 'pass',
      'canonical_acceptance' => 'pending',
      'references' => { 'canonical_acceptance_record' => nil },
      'evidence' => [{ 'type' => 'test_run' }]
    }
  end

  def project(order = valid_order, url: URL, revision: REV)
    WRASAL::WorkOrderProjection.project(document: order, source_url: url, revision: revision)
  end

  def test_executor_pass_does_not_make_done
    props = project.fetch('properties')
    assert_equal 'In progress', props['Status']
    assert_equal 'pending', props['Control Acceptance']
    assert_equal 'PARTIAL', props['Evidence Status']
    assert_equal 'LIVE MIRROR', props['Record Class']
    assert_equal 'pass', props['Control Verification']
  end

  def test_accepted_text_and_link_does_not_create_authority
    order = valid_order
    order['canonical_acceptance'] = 'accepted'
    assert_equal 'In progress', project(order).fetch('properties').fetch('Status')
    order['references']['canonical_acceptance_record'] = 'https://example.org/review/approved'
    assert_equal 'In progress', project(order).fetch('properties').fetch('Status')
    order['verification_result'] = 'unknown'
    assert_equal 'In progress', project(order).fetch('properties').fetch('Status')
  end

  def test_pending_work_is_not_started
    order = valid_order
    order['execution_status'] = 'requested'
    order['verification_result'] = 'unknown'
    props = project(order).fetch('properties')
    assert_equal 'Not started', props['Status']
    assert_equal 'SCOPE', props['Delivery Gate']
  end

  def test_rejects_cross_repository_reference_and_mismatched_id
    assert_raises(WRASAL::WorkOrderProjection::InvalidSource) do
      project(url: 'https://github.com/other/repo/blob/main/work_orders/WRASAL-0005.json')
    end
    bad = valid_order.merge('work_order_id' => 'WRASAL-9999')
    assert_raises(WRASAL::WorkOrderProjection::InvalidSource) { project(bad) }
  end

  def test_rejects_invalid_status_and_unpinned_revision
    invalid = valid_order.merge('verification_result' => 'SUCCESS')
    assert_raises(WRASAL::WorkOrderProjection::InvalidSource) { project(invalid) }
    assert_raises(WRASAL::WorkOrderProjection::InvalidSource) { project(revision: 'main') }
  end

  def test_output_contains_no_side_effect_instructions
    result = project
    refute result.key?('transition')
    refute result.key?('approval')
    refute result.fetch('properties').key?('Acceptance Evidence')
  end
end
