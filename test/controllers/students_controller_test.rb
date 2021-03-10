require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert defines_before_filter?(StudentsController, :authenticate_user!)
  end

  test 'redirects requests from unauthenticated sessions' do
    # index
    get students_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # show
    get student_path('fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # edit
    get edit_student_path('fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch student_path('fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put student_path('fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # reset_teachers
    patch reset_teachers_students_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put reset_teachers_students_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

  test 'restricts student access' do
    assert defines_before_filter?(StudentsController, :restrict_from_students)
  end

  test 'redirects requests from student users to student view' do
    student = users(:student)
    sign_in student
    # index
    get students_path
    assert_redirected_to student_path(student)
    # edit
    get edit_student_path('fake')
    assert_redirected_to student_path(student)
    # update
    patch reset_teachers_students_path
    assert_redirected_to student_path(student)
  end

  test 'does not redirect #show requests from student users' do
    student = users(:student)
    sign_in student
    get student_path(student)
    assert_response :success
  end

  # Multi-tenancy

  test 'redirects requests for another school\'s students' do
    sign_in users(:third_staff)
    other_school_student = users(:student)
    # show
    get student_path(other_school_student)
    assert_redirected_to students_path
    # edit
    get edit_student_path(other_school_student)
    assert_redirected_to students_path
    # update
    patch student_path(other_school_student)
    assert_redirected_to students_path
    put student_path(other_school_student)
    assert_redirected_to students_path
  end

end
