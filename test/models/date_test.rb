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

  test "thursday returns this tuesday's date" do
    assert_equal @date.thursday, Date.today.monday + 3
  end

  test "friday returns this tuesday's date" do
    assert_equal @date.friday, Date.today.monday + 4
  end

end
