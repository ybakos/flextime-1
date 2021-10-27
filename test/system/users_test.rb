require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  test 'todo' do
    skip
  end

  # https://github.com/osu-cascades/falcon-time/issues/72
  test 'user who signs out, goes back, and POSTs is redirected to sign in' do
    skip
  end

  # https://github.com/osu-cascades/flex-time/issues/178
  test 'user whose role changes from student to staff raises exception' do
    staff_signing_in_first_time = users(:new_student_without_teacher)
    sign_in staff_signing_in_first_time
    visit root_path
    staff_signing_in_first_time.update_attribute(:role, :staff) # Admin changes role to staff
    select 'Miss Valid'
    click_on 'Ok'
    assert_text 'Student not found'
  end

end
