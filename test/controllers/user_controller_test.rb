require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert defines_before_filter?(UsersController, :authenticate_user!)
  end

  test 'redirects requests from unauthenticated sessions' do
    # index
    get users_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch user_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put user_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

  test 'restricts student access' do
    assert defines_before_filter?(UsersController, :restrict_from_students)
  end

  test 'redirects requests from student users to student view' do
    student = users(:student)
    sign_in student
    # index
    get users_path
    assert_redirected_to student_path(student)
    # update
    patch user_path(id: 'fake')
    assert_redirected_to student_path(student)
    put user_path(id: 'fake')
    assert_redirected_to student_path(student)
  end

  test 'restricts staff access' do
    assert defines_before_filter?(UsersController, :restrict_unless_admin)
  end

  test 'redirects requests from staff users to root url' do
    staff = users(:staff)
    sign_in staff
    # index
    get users_path
    assert_redirected_to root_url
    # update
    patch user_path(id: 'fake')
    assert_redirected_to root_url
    put user_path(id: 'fake')
    assert_redirected_to root_url
  end

  test 'allows requests from admin users' do
    admin = users(:admin)
    sign_in admin
    # index
    get users_path
    assert_response(:success)
    # update
    patch user_path(id: users(:staff), 'user[active]': true)
    assert_redirected_to users_path
    put user_path(id: users(:staff), 'user[active]': true)
    assert_redirected_to users_path
  end

end
