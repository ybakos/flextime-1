require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'has a default role of student' do
    new_user = User.new
    assert_equal new_user.role, 'student'
  end

  test 'pre-existing User without defined role has a default role of student' do
    assert_equal users(:one).role, 'student'
  end

  test 'has a string representation of first_name last_name' do
    assert_equal users(:one).to_s, 'Fake User'
  end

end
