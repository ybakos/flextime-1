require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  test "without a name is invalid" do
    teacher = teachers(:valid)
    assert teacher.valid?
    teacher.name = nil
    assert !teacher.valid?
  end

  test "without a title is invalid" do
    teacher = teachers(:valid)
    assert teacher.valid?
    teacher.title = nil
    assert !teacher.valid?
  end
end
