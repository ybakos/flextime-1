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
    # update
    patch student_path('fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put student_path('fake')
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
  end

  test 'does not redirect #show requests from student users' do
    student = users(:student)
    sign_in student
    get student_path(student)
    assert_response :success
  end

end
