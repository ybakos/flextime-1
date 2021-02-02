require 'test_helper'

class SysAdminSchoolsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert(defines_before_filter?(SysAdmin::SchoolsController, :authenticate_user!))
  end

  test 'requires a sys_admin user' do
    assert(defines_before_filter?(SysAdmin::SchoolsController, :restrict_unless_sys_admin))
  end

  test 'redirects requests from unauthenticated sessions' do
    # index
    get sys_admin_schools_path
    assert_redirected_to new_user_session_path
    # show
    get sys_admin_school_path(id: 'fake')
    assert_redirected_to new_user_session_path
    # new
    get new_sys_admin_school_path
    assert_redirected_to new_user_session_path
    # edit
    get edit_sys_admin_school_path(id: 'fake')
    assert_redirected_to new_user_session_path
    # create
    post sys_admin_schools_path
    assert_redirected_to new_user_session_path
    # update
    patch sys_admin_school_path(id: 'fake')
    assert_redirected_to new_user_session_path
    put sys_admin_school_path(id: 'fake')
    assert_redirected_to new_user_session_path
    # destroy
    delete sys_admin_school_path(id: 'fake')
    assert_redirected_to new_user_session_path
  end

  test 'redirects requests from admin users to root url' do
    sign_in users(:admin)
    # index
    get sys_admin_schools_path
    assert_redirected_to root_url
    # show
    get sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    # new
    get new_sys_admin_school_path
    assert_redirected_to root_url
    # edit
    get edit_sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    # create
    post sys_admin_schools_path
    assert_redirected_to root_url
    # update
    patch sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    put sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    # destroy
    delete sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
  end

  test 'redirects requests from staff users to root url' do
    sign_in users(:staff)
    # index
    get sys_admin_schools_path
    assert_redirected_to root_url
    # show
    get sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    # new
    get new_sys_admin_school_path
    assert_redirected_to root_url
    # edit
    get edit_sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    # create
    post sys_admin_schools_path
    assert_redirected_to root_url
    # update
    patch sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    put sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
    # destroy
    delete sys_admin_school_path(id: 'fake')
    assert_redirected_to root_url
  end

  test 'redirects requests from student users to student path' do
    student = users(:student)
    sign_in student
    # index
    get sys_admin_schools_path
    assert_redirected_to student_path(student)
    # show
    get sys_admin_school_path(id: 'fake')
    assert_redirected_to student_path(student)
    # new
    get new_sys_admin_school_path
    assert_redirected_to student_path(student)
    # edit
    get edit_sys_admin_school_path(id: 'fake')
    assert_redirected_to student_path(student)
    # create
    post sys_admin_schools_path
    assert_redirected_to student_path(student)
    # update
    patch sys_admin_school_path(id: 'fake')
    assert_redirected_to student_path(student)
    put sys_admin_school_path(id: 'fake')
    assert_redirected_to student_path(student)
    # destroy
    delete sys_admin_school_path(id: 'fake')
    assert_redirected_to student_path(student)
  end
end
