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

  test 'admins view a list of users' do
    sign_in users(:admin)
    visit users_url
    click_on 'S'
    assert_text users(:student).last_name_first_name
  end

  # Multi-tenancy

  test 'admins of one school do not see users from another school' do
    # From test 'admins view a list of users'
    sign_in users(:second_admin)
    visit users_url
    click_on 'S'
    refute_text users(:student).last_name_first_name
  end

  test 'is invalid if the teacher does not belong to the same school' do
    first_school_student = users(:student)
    assert first_school_student.valid?
    first_school_student.teacher = teachers(:third_school_teacher)
    refute first_school_student.valid?
  end

end
