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

  test 'belongs to a school' do
    assert_respond_to registrations(:by_student), :school
    assert_kind_of School, registrations(:by_student).school
  end

  test 'has a default attendance of present' do
    registration = Registration.new
    assert_equal registration.attendance, 'present'
  end

  test 'is invalid if associated student User does not have student role' do
    registration = registrations(:by_staff)
    assert registration.valid?
    registration.student = users(:staff)
    refute registration.valid?
  end

  test 'is invalid if teacher is not present' do
    registration = registrations(:by_student)
    assert registration.valid?
    registration.student = users(:new_student_without_teacher)
    registration.teacher = nil
    refute registration.valid?
  end

  test 'is invalid if student teacher is not the same as the teacher during initial registration' do
    student = users(:student)
    ActsAsTenant.with_tenant(student.school) do
      registration = Registration.new(
        creator: student,
        student: student,
        teacher: student.teacher,
        activity: activities(:friday_activity))
      assert registration.valid?
      registration.teacher = teachers(:mr_valid)
      refute registration.valid?
    end
  end

  test 'is valid if student teacher is not the same as the teacher during update' do
    registration = registrations(:by_staff)
    assert registration.valid?
    registration.teacher = teachers(:mr_valid)
    assert registration.valid?
  end

  # students may only register themselves
  test 'is invalid if student registrant (creator) is not the registration student' do
    student = users(:student)
    ActsAsTenant.with_tenant(student.school) do
      new_registration = Registration.new(
        creator: student,
        student: users(:second_student),
        teacher: users(:second_student).teacher,
        activity: activities(:friday_activity))
      refute new_registration.valid?
    end
  end

  # students may not register themselves for restricted activities
  # https://github.com/osu-cascades/flex-time/issues/117
  test 'is invalid if the student is the registrant and the activity is restricted' do
    student = users(:student)
    ActsAsTenant.with_tenant(student.school) do
      new_registration = Registration.new(creator: student,
        student: student,
        teacher: student.teacher,
        activity: activities(:restricted))
      refute new_registration.valid?
    end
  end

  test 'is invalid if any associated objects schools do not match the registration school' do
    registration = registrations(:by_staff)
    assert registration.valid?
    registration.student = users(:third_school_student)
    refute registration.valid?
  end

  # Students may only register for an activity once
  test 'must be unique for the student and activity' do
    existing_registration = registrations(:by_student)
    ActsAsTenant.with_tenant(existing_registration.school) do
      new_registration = Registration.new(
        creator: existing_registration.creator,
        student: existing_registration.student,
        teacher: existing_registration.teacher,
        activity: activities(:friday_activity))
      assert new_registration.valid?
      new_registration.activity = existing_registration.activity
      refute new_registration.valid?
    end
  end

  test 'is invalid if the student has another registration for an activity on the same date' do
    existing_registration = registrations(:by_student)
    ActsAsTenant.with_tenant(existing_registration.school) do
      new_registration = Registration.new(
        creator: existing_registration.creator,
        student: existing_registration.student,
        teacher: existing_registration.teacher,
        activity: activities(:friday_activity))
      assert new_registration.valid?
      new_registration.activity = activities(:second_tuesday_activity)
      refute new_registration.valid?
    end
  end

  test 'is invalid if the activity is full' do
    full_activity = activities(:tuesday_activity)
    ActsAsTenant.with_tenant(full_activity.school) do
      new_registration = Registration.new(
        creator: users(:second_student),
        student: users(:second_student),
        teacher: users(:second_student).teacher,
        activity: full_activity
      )
      refute new_registration.valid?
    end
  end

  test 'is invalid if the creator is a student and the activity is more than eight days away' do
    student = users(:student)
    activity = activities(:next_friday_activity)
    ActsAsTenant.with_tenant(student.school) do
      registration = Registration.new(activity: activity, creator: student, student: student, teacher: student.teacher)
      travel_to Date.today.thursday do
        refute registration.valid?
      end
      travel_to Date.today.friday do
        assert registration.valid?
      end
    end
  end

  # ::for_week

  test 'returns a hash of tuesday, thursday and friday registrations for the current week given any date this week' do
    ActsAsTenant.with_tenant(schools(:first)) do
      date = Date.today.beginning_of_week
      expected = {
        date.tuesday => registrations(:by_student),
        date.thursday => registrations(:by_staff),
        date.friday => nil
      }
      (0..6).each do |offset|
        assert_equal expected, Registration.for_week(date + offset)
      end
    end
  end

  # Multi-tenancy

  test '::for_week does not include registrations for a different school' do
    ActsAsTenant.with_tenant(schools(:first)) do
      date = Date.today.beginning_of_week + 7
      expected = {
        date.tuesday => registrations(:next_week),
        date.thursday => nil,
        date.friday => nil
      }
      (0..6).each do |offset|
        assert_equal expected, Registration.for_week(date + offset)
      end
    end
    ActsAsTenant.with_tenant(schools(:third)) do
      date = Date.today.beginning_of_week + 7
      expected = {
        date.tuesday => registrations(:third_school),
        date.thursday => nil,
        date.friday => nil
      }
      (0..6).each do |offset|
        assert_equal expected, Registration.for_week(date + offset)
      end
    end
  end


end
