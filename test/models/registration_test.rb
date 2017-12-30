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

end
