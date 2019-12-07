require 'test_helper'

class TeacherTest < ActiveSupport::TestCase

  test 'without a name is invalid' do
    teacher = teachers(:miss_valid)
    assert teacher.valid?
    teacher.name = nil
    assert teacher.invalid?
  end

  test 'trims whitespace around any initial name' do
    bad_names = [' FAKE', 'FAKE ', ' FAKE ']
    teacher = Teacher.new
    bad_names.each do |name|
      teacher.name = name
      assert_equal(teacher.name, 'FAKE')
    end
  end

  test 'without a title is invalid' do
    teacher = teachers(:miss_valid)
    assert teacher.valid?
    teacher.title = nil
    assert teacher.invalid?
  end

  test 'without an acceptable title value is invalid' do
    assert teachers(:invalid_title).invalid?
  end

  test 'string representation is title. name' do
    assert_equal teachers(:miss_valid).to_s, 'Miss Valid'
  end

  test 'previous string representation is title. name before modification' do
    teacher = teachers(:miss_valid)
    assert_equal teacher.to_s, 'Miss Valid'
    teacher.name = 'FAKE'
    assert_equal teacher.to_s, 'Miss FAKE'
    assert_equal teacher.to_s_was, 'Miss Valid'
  end

  test 'has a unique title and name' do
    existing_teacher = teachers(:miss_valid)
    teacher = Teacher.new(title: existing_teacher.title, name: existing_teacher.name)
    assert_raises { teacher.save! }
  end

  test 'has many students' do
    assert_respond_to(teachers(:miss_valid), :students)
    assert_kind_of User, teachers(:miss_valid).students.first
  end

  test 'is active by default' do
    teacher = Teacher.new
    assert teacher.active?
  end

  test 'is not active after being deactivated' do
    teacher = teachers(:miss_valid)
    assert teacher.active?
    teacher.deactivate!
    refute teacher.active?
  end

  test 'deactivation causes students to be disassociated' do
    teacher = teachers(:miss_valid)
    students = [users(:student), users(:second_student)]
    students.each { |s| assert_equal(s.teacher, teacher) }
    teacher.deactivate!
    students.each(&:reload)
    students.each { |s| assert(s.teacher.nil?) }
  end

  test 'is active after being activated' do
    teacher = teachers(:deactivated)
    refute teacher.active?
    teacher.activate!
    assert teacher.active?
  end

  test '#can_be_deleted? is true when it has neither students nor registrations' do
    teacher = teachers(:mr_fake)
    assert_empty(teacher.students)
    assert_empty(teacher.registrations)
    assert(teacher.can_be_deleted?)
  end

  test '#can_be_deleted? is false when it has students and/or registrations' do
    teacher = teachers(:mr_fake)
    assert_empty(teacher.students)
    assert_empty(teacher.registrations)
    teacher.students << User.new
    refute(teacher.can_be_deleted?)
    teacher = teachers(:mr_valid)
    assert_empty(teacher.students)
    refute_empty(teacher.registrations)
    refute(teacher.can_be_deleted?)
    teacher = teachers(:miss_valid)
    refute_empty(teacher.students)
    refute_empty(teacher.registrations)
    refute(teacher.can_be_deleted?)
  end

  test 'generates and error when destroyed if it has students' do
    teacher = teachers(:miss_valid)
    assert_empty(teacher.errors)
    teacher.destroy
    assert_not_empty(teacher.errors)
    assert_nothing_raised { teacher.reload } # not deleted from the database
  end

  test 'generates and error when destroyed if it has registrations' do
    teacher = teachers(:mr_valid)
    assert_empty(teacher.errors)
    teacher.destroy
    assert_not_empty(teacher.errors)
    assert_nothing_raised { teacher.reload } # not deleted from the database
  end

  test 'can be destroyed when it has neither students nor registrations' do
    teacher = teachers(:mr_fake)
    assert_nothing_raised { teacher.destroy }
    assert_empty(teacher.errors)
    assert_raises(ActiveRecord::RecordNotFound) { teacher.reload }
  end

end
