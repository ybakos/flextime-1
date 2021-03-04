require 'application_system_test_case'

class AttendanceTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:staff)
    visit activities_url
  end

  # Default Attendance

  test 'attendance status is shown as _present_ by default' do
    click_link 'Fake Tuesday Activity'
    assert_selector '.badge-success', count: 1
    within('.badge-success') { assert_text 'present' }
    assert_no_selector '.badge-warning'
    assert_no_selector '.badge-danger'
  end

  test 'attendance list does not show present students' do
    first('.lnk-attendance').click
    assert_text 'Attendance'
    assert_no_text 'late'
    assert_no_text 'absent'
  end

  # Marking Attendance

  test 'staff marks student as late' do
    click_link 'Fake Tuesday Activity'
    click_link 'late'
    assert_text 'Attendance marked'
    assert_selector '.badge-warning', count: 1
    within('.badge-warning') { assert_text 'late' }
    assert_no_selector '.badge-success'
    assert_no_selector '.badge-danger'
  end

  test 'staff sees late students in attendance list' do
    registrations(:by_student).late!
    first('.lnk-attendance').click
    assert_text 'Attendance'
    assert_text 'late'
  end

  test 'staff marks student as absent' do
    click_link 'Fake Tuesday Activity'
    click_link 'absent'
    assert_text 'Attendance marked'
    assert_selector '.badge-danger', count: 1
    within('.badge-danger') { assert_text 'absent' }
    assert_no_selector '.badge-success'
    assert_no_selector '.badge-warning'
  end

  test 'staff sees absent students in attendance list' do
    registrations(:by_student).absent!
    first('.lnk-attendance').click
    assert_text 'Attendance'
    assert_text 'absent'
  end

  # Multi-tenancy

  test 'attendance records of one school are not visible by users of another school' do
    # From test 'staff sees late students in attendance list'
    registrations(:by_student).late!
    sign_in users(:second_staff)
    visit activities_url
    first('.lnk-attendance').click
    assert_text 'Attendance'
    refute_text registrations(:by_student).student.last_name_first_name
    refute_text 'late'
  end

end
