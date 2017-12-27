require 'test_helper'

class TeachersControllerTest < ActionDispatch::IntegrationTest

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
    # destroy
    delete teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

end
