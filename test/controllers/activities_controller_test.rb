require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest

  test 'requires user authentication' do
    assert defines_before_filter?(ActivitiesController, :authenticate_user!)
  end

  test 'redirects requests from unauthenticated sessions' do
    # index
    get activities_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # show
    get activity_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # new
    get new_activity_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # edit
    get edit_activity_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # create
    post activities_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch activity_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put activity_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # destroy
    delete activity_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

end
