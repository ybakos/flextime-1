require 'test_helper'

class TeachersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert defines_before_filter?(TeachersController, :authenticate_user!)
  end

  test 'redirects requests from unauthenticated sessions' do
    # index
    get teachers_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # show
    get teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # edit
    get edit_teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # create
    post teachers_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

  test 'restricts student access' do
    assert defines_before_filter?(TeachersController, :restrict_from_students)
  end

  test 'redirects requests from student users to student view' do
    student = users(:student)
    sign_in student
    # index
    get teachers_path
    assert_redirected_to student_path(student)
    # show
    get teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # edit
    get edit_teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # create
    post teachers_path
    assert_redirected_to student_path(student)
    # update
    patch teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    put teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
  end

end
