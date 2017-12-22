require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  test 'without a name is invalid' do
    activity = activities(:tuesday_activity)
    assert activity.valid?
    activity.name = nil
    assert activity.invalid?
  end

  test 'without a room is invalid' do
    activity = activities(:tuesday_activity)
    assert activity.valid?
    activity.room = nil
    assert activity.invalid?
  end

  test 'without a capacity is invalid' do
    activity = activities(:tuesday_activity)
    assert activity.valid?
    activity.capacity = nil
    assert activity.invalid?
  end

  test 'capacity is an integer greater than or equal to 0' do
    activity = activities(:tuesday_activity)
    assert activity.valid?
    activity.capacity = -1
    assert activity.invalid?
    activity.capacity = 2.3
    assert activity.invalid?
  end

  test 'without a date is invalid' do
    activity = activities(:tuesday_activity)
    assert activity.valid?
    activity.date = nil
    assert activity.invalid?
  end

  test 'string representation includes name, room and title' do
    a = activities(:tuesday_activity)
    assert_equal a.to_s, "#{a.name} (#{a.room}) on #{I18n.l a.date, format: :complete}"
  end

end
