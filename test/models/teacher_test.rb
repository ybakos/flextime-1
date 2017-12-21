require 'test_helper'

class TeacherTest < ActiveSupport::TestCase

  test 'without a name is invalid' do
    teacher = teachers(:miss_valid)
    assert teacher.valid?
    teacher.name = nil
    assert teacher.invalid?
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
  end

end
