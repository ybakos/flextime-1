require 'test_helper'

class DateTest < ActiveSupport::TestCase

  setup do
    @date = Date.today
  end

  test 'day_name property returns the name of the day of the week' do
    assert_equal @date.day_name, @date.strftime("%A")
  end

  test "tuesday returns this tuesday's date" do
    assert_equal @date.tuesday, Date.today.monday + 1
  end

  test "wednesday returns this wednesday's date" do
    assert_equal @date.wednesday, Date.today.monday + 2
  end

  test "thursday returns this tuesday's date" do
    assert_equal @date.thursday, Date.today.monday + 3
  end

  test "friday returns this tuesday's date" do
    assert_equal @date.friday, Date.today.monday + 4
  end

  test "current_week? is true when date is of the current week" do
    assert @date.current_week?
    refute (@date - 7).current_week?
  end

  test "less_than_a_week_away?" do
    assert @date.less_than_a_week_away?
    travel_to Date.today.monday do
      refute (Date.today.next_week + 1).less_than_a_week_away?
    end
  end

end
