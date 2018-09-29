require 'test_helper'

class WeekTest < ActiveSupport::TestCase

  test 'ACTIVITY_DAYS consists of days of the week' do
    Week::ACTIVITY_DAYS.each do |day|
      assert_includes Week::DAYS, day
    end
  end

  test '#to_string_array' do
    assert_equal Week::ACTIVITY_DAYS.map { |day| day.to_s.capitalize }, Week.to_string_array
  end

  test '#to_sentence' do
    assert_equal Week::ACTIVITY_DAYS.map { |day| day.to_s.capitalize }.to_sentence(last_word_connector: ', or '), Week.to_sentence(', or ')
  end

end
