require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase

  test 'has a creator that is a User' do
    assert_respond_to registrations(:by_student), :creator
    assert_kind_of User, registrations(:by_student).creator
  end

  test 'has a student that is a User' do
    assert_respond_to registrations(:by_student), :student
    assert_kind_of User, registrations(:by_student).student
  end

  test 'has a teacher' do
    assert_respond_to registrations(:by_student), :teacher
    assert_kind_of Teacher, registrations(:by_student).teacher
  end

  test 'has an activity' do
    assert_respond_to registrations(:by_student), :activity
    assert_kind_of Activity, registrations(:by_student).activity
  end

  test 'is invalid if associated student User does not have student role' do
    registration = registrations(:by_staff)
    assert registration.valid?
    registration.student = users(:staff)
    refute registration.valid?
  end

  test 'is invalid if student teacher is not the same as the teacher' do
    registration = registrations(:by_staff)
    assert registration.valid?
    registration.teacher = teachers(:mr_valid)
    refute registration.valid?
  end

  # Students may only register for an activity once
  test 'must be unique for the student and activity' do
    existing_registration = registrations(:by_student)
    new_registration = Registration.new(creator: existing_registration.creator,
      student: existing_registration.student,
      teacher: existing_registration.teacher,
      activity: activities(:friday_activity))
    assert new_registration.valid?
    new_registration.activity = existing_registration.activity
    refute new_registration.valid?
  end

  test 'when new, is invalid if the student has another registration for an activity on the same date' do
    existing_registration = registrations(:by_student)
    new_registration = Registration.new(creator: existing_registration.creator,
      student: existing_registration.student,
      teacher: existing_registration.teacher,
      activity: activities(:friday_activity))
    assert new_registration.valid?
    new_registration.activity = activities(:second_tuesday_activity)
    refute new_registration.valid?
  end

end
