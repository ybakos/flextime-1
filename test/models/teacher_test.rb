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

end
