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
    # show
    get user_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # edit
    get edit_user_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch user_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put user_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # destroy
    delete user_path(id: 'fake')
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
    # show
    get user_path(id: 'fake')
    assert_redirected_to student_path(student)
    # edit
    get edit_user_path(id: 'fake')
    assert_redirected_to student_path(student)
    # update
    patch user_path(id: 'fake')
    assert_redirected_to student_path(student)
    put user_path(id: 'fake')
    assert_redirected_to student_path(student)
    # destroy
    delete user_path(id: 'fake')
    assert_redirected_to student_path(student)
  end

end
