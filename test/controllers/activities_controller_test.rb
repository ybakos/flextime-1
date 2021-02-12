require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

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
    # attendance
    get attendance_activities_path
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
    # copy
    post copy_activities_path
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

  test 'restricts student access' do
    assert defines_before_filter?(ActivitiesController, :restrict_from_students)
  end

  test 'redirects requests from student users to student view' do
    student = users(:student)
    sign_in student
    # index
    get activities_path
    assert_redirected_to student_path(student)
    # show
    get activity_path(id: 'fake')
    assert_redirected_to student_path(student)
    # attendance
    get attendance_activities_path
    assert_redirected_to student_path(student)
    # new
    get new_activity_path
    assert_redirected_to student_path(student)
    # edit
    get edit_activity_path(id: 'fake')
    assert_redirected_to student_path(student)
    # create
    post activities_path
    assert_redirected_to student_path(student)
    # copy
    post copy_activities_path
    assert_redirected_to student_path(student)
    # update
    patch activity_path(id: 'fake')
    assert_redirected_to student_path(student)
    put activity_path(id: 'fake')
    assert_redirected_to student_path(student)
    # destroy
    delete activity_path(id: 'fake')
    assert_redirected_to student_path(student)
  end

  test 'redirects delete requests from staff users to activities url' do
    sign_in users(:staff)
    delete activity_path(activities(:tuesday_activity))
    assert_redirected_to activities_url
  end

  test 'allows admins to delete an activity' do
    sign_in users(:admin)
    activity = activities(:tuesday_activity)
    delete activity_path(activity)
    assert_redirected_to activities_path(date: activity.week_date)
    assert_match /Fake Tuesday Activity was successfully deleted/, flash[:notice]
  end

  test 'redirects copy requests from staff users to activities url' do
    sign_in users(:staff)
    post copy_activities_path
    assert_redirected_to activities_url
  end

  test 'redirects when the activity is not found' do
    sign_in users(:staff)
    get activity_path(id: 'fake')
    assert_redirected_to activities_path
    assert_match /activity seems to have just been removed/, flash[:alert]
  end

  # Multi-tenancy

  test 'redirects requests for another school\'s activity' do
    sign_in users(:second_staff)
    other_school_activity = activities(:tuesday_activity)
    # show
    get activity_path(other_school_activity)
    assert_redirected_to activities_path
    # edit
    get edit_activity_path(other_school_activity)
    assert_redirected_to activities_path
    # update
    patch activity_path(other_school_activity)
    assert_redirected_to activities_path
    put activity_path(other_school_activity)
    assert_redirected_to activities_path
    # destroy
    delete activity_path(other_school_activity)
    assert_redirected_to activities_path
  end

end
