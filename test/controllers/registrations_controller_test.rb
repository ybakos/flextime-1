require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert defines_before_filter?(RegistrationsController, :authenticate_user!)
  end

  test 'redirects requests from unauthenticated sessions' do
    # edit
    get edit_student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # create
    post student_registrations_path(student_id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # mark attendance
    patch mark_attendance_student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # destroy
    delete student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

  test 'restricts student access' do
    assert defines_before_filter?(RegistrationsController, :restrict_from_students)
  end

  test 'redirects requests from student users to student view' do
    student = users(:student)
    sign_in student
    # edit
    get edit_student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to student_path(student)
    # update
    patch student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to student_path(student)
    put student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to student_path(student)
    # mark attendance
    patch mark_attendance_student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to student_path(student)
    # destroy
    delete student_registration_path(student_id: 'fake', id: 'fake')
    assert_redirected_to student_path(student)
  end

  test 'does not allow students to create a registration for another student' do
    student = users(:student)
    other_student = users(:second_student)
    sign_in student
    post student_registrations_path(other_student)
    assert_redirected_to student_path(student)
    assert_match /only register yourself/, flash[:alert]
  end

  test 'allows staff to edit a registration' do
    sign_in users(:staff)
    registration = registrations(:by_student)
    get edit_student_registration_path(registration.student, registration)
    assert_response :success
  end

  test 'allows staff to update a registration' do
    sign_in users(:staff)
    registration = registrations(:by_student)
    put student_registration_path(registration.student, registration, params: {registration: {activity_id: registration.activity_id}})
    assert_redirected_to student_path(registration.student, date: registration.activity.week_date)
    patch student_registration_path(registration.student, registration, params: {registration: {activity_id: registration.activity_id}})
    assert_redirected_to student_path(registration.student, date: registration.activity.week_date)
  end

  test 'allows staff to update attendance' do
    sign_in users(:staff)
    registration = registrations(:by_student)
    patch mark_attendance_student_registration_path(registration.student, registration, params: {attendance: 'late'})
    assert_redirected_to activity_path(registration.activity)
  end

  test 'allows staff to delete a registration' do
    sign_in users(:staff)
    registration = registrations(:by_student)
    delete student_registration_path(registration.student, registration)
    assert_redirected_to student_path(registration.student, date: registration.activity.week_date)
    assert_match /was removed from/, flash[:notice]
  end

  test 'redirects when activity no longer exists' do
    student = users(:student)
    sign_in student
    post student_registrations_path(student, params: {registration: {activity_id: '0'}})
    assert_redirected_to student_path(student)
    assert_match /choose a different activity/, flash[:alert]
  end

  test 'redirects when the registration no longer exists' do
    sign_in users(:staff)
    registration = registrations(:by_student)
    get edit_student_registration_path(registration.student, id: 'fake')
    assert_redirected_to student_path(registration.student)
    assert_match /registration seems to have been deleted/, flash[:alert]
  end

  # Multi-tenancy

  test 'redirects requests for marking attendance of another school' do
    # From test 'allows staff to update attendance'
    sign_in users(:second_staff)
    other_school_registration = registrations(:by_student)
    patch mark_attendance_student_registration_path(
      other_school_registration.student, other_school_registration, params: {attendance: 'late'})
    assert_redirected_to student_path(other_school_registration.student)
    # Note: students_controller would then send another redirect, since the student
    # is not of the same tenant as the current user. But, we're don't test that here.
    # You can check it with follow_redirect! here, if you wish.
  end

  test 'redirects requests for another school\'s registration' do
    # Note: students_controller would then send another redirect, since the student
    # is not of the same tenant as the current user. But, we're don't test that here.
    # You can check it with follow_redirect! if you wish.
    sign_in users(:second_staff)
    other_school_registration = registrations(:by_student)
    # edit
    get edit_student_registration_path(other_school_registration.student, other_school_registration)
    assert_redirected_to student_path(other_school_registration.student)
    # update
    patch student_registration_path(other_school_registration.student, other_school_registration)
    assert_redirected_to student_path(other_school_registration.student)
    put student_registration_path(other_school_registration.student, other_school_registration)
    assert_redirected_to student_path(other_school_registration.student)
    # destroy
    delete student_registration_path(other_school_registration.student, other_school_registration)
    assert_redirected_to student_path(other_school_registration.student)
  end

end
