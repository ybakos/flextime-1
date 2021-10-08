require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'student signs in and out' do
    student = users(:student)
    sign_in student
    get student_path(student)
    assert_response :success
    delete destroy_user_session_path
    assert_redirected_to new_user_session_path
  end

  test 'staff signs in and out' do
    staff = users(:staff)
    sign_in staff
    get activities_path
    assert_response :success
    delete destroy_user_session_path
    assert_redirected_to new_user_session_path
  end

  test 'deactivated staff can not sign in' do
    deactivated_user = users(:deactivated)
    sign_in deactivated_user
    get root_url
    assert_redirected_to new_user_session_path
  end

  test 'deactivated student can sign in' do
    deactivated_student = users(:deactivated_student)
    sign_in deactivated_student
    get root_url
    assert_response :success
  end

end
