require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest

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

end
