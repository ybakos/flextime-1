require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  def activity
    activities(:tuesday_activity)
  end

  test 'is not restricted by default' do
    refute Activity.new.restricted
  end

  test 'without a name is invalid' do
    assert activity.valid?
    activity.name = nil
    assert activity.invalid?
  end

  test 'without a room is invalid' do
    assert activity.valid?
    activity.room = nil
    assert activity.invalid?
  end

  test 'without a capacity is invalid' do
    assert activity.valid?
    activity.capacity = nil
    assert activity.invalid?
  end

  test 'capacity is an integer greater than or equal to 0' do
    assert activity.valid?
    activity.capacity = -1
    assert activity.invalid?
    activity.capacity = 2.3
    assert activity.invalid?
  end

  test 'without a date is invalid' do
    assert activity.valid?
    activity.date = nil
    assert activity.invalid?
  end

  test "without a date on #{Week.to_sentence(' or ')} is invalid" do
    assert activity.valid?
    invalid_day = (Week::DAYS - Week::ACTIVITY_DAYS).first
    activity.date = activity.date.send(invalid_day)
    assert activity.invalid?
  end

  test 'has a unique name, room and date' do
    existing_activity = activity
    activity = Activity.new(name: existing_activity.name, room: existing_activity.room, date: existing_activity.date)
    assert_raises { activity.save! }
  end

  test 'has registrations' do
    assert_respond_to activities(:tuesday_activity), :registrations
    assert_kind_of Registration, activities(:tuesday_activity).registrations.first
  end

  test 'string representation includes name, room and date' do
    assert_equal activity.to_s, "Fake Tuesday Activity (Fake Room) on #{activity.date.strftime("%A, %b %-e %Y")}"
  end

  test 'previous string representation includes name, room and date before modification' do
    a = activity
    assert_equal a.to_s, "Fake Tuesday Activity (Fake Room) on #{a.date.strftime("%A, %b %-e %Y")}"
    a.name = 'FAKE'
    assert_equal a.to_s, "FAKE (Fake Room) on #{a.date.strftime("%A, %b %-e %Y")}"
    assert_equal a.to_s_was, "Fake Tuesday Activity (Fake Room) on #{a.date.strftime("%A, %b %-e %Y")}"
  end

  test '#day_and_room' do
    a = activity
    assert_equal a.day_and_room, "#{I18n.l(a.date, format: :without_year)} in #{a.room}"
  end

  # full?

  test 'is full when the number of registrations equal capacity' do
    assert activity.full?
  end

  test 'is not full when the number of registrations does not exceed capacity' do
    refute activities(:friday_activity).full?
  end

  # week_date

  test 'returns the monday of the week of the activity' do
    assert_equal activity.week_date, activity.date.monday
  end

  # ::for_week

  test 'returns a hash of tuesday, thursday and friday activities for the current week given any date this week' do
    date = Date.today.beginning_of_week
    expected = {
      date.tuesday => [activities(:tuesday_activity), activities(:second_tuesday_activity)],
      date.thursday => [activities(:thursday_activity), activities(:second_thursday_activity)],
      date.friday => [activities(:friday_activity), activities(:restricted)]
    }
    (0..6).each do |offset|
      assert_equal expected, Activity.for_week(date + offset)
    end
  end

  test 'returns a hash of tuesday, thursday and friday activities for the previous week given any date in the previous week' do
    date = Date.today.beginning_of_week
    expected = {
      date.prev_week.tuesday => [activities(:last_tuesday_activity)],
      date.prev_week.thursday => [activities(:last_thursday_activity)],
      date.prev_week.friday => [activities(:last_friday_activity)]
    }
    (-6..-1).each do |offset|
      assert_equal expected, Activity.for_week(date + offset)
    end
  end

  test 'returns a hash of tuesday, thursday and friday activities for next week given any date next week' do
    date = Date.today.beginning_of_week
    expected = {
      date.next_week.tuesday => [activities(:next_tuesday_activity)],
      date.next_week.thursday => [activities(:next_thursday_activity)],
      date.next_week.friday => [activities(:next_friday_activity)]
    }
    (7..13).each do |offset|
      assert_equal expected, Activity.for_week(date + offset)
    end
  end

  # ::available_on_date

  test 'returns a list of activities that are not full on a date' do
    available_activities = Activity.available_on_date(Date.today.tuesday)
    refute_includes(available_activities, activities(:tuesday_activity))
  end

  # ::copy!

  test 'creates new activities based on activities from another date' do
    from = Date.today.tuesday
    to = 2.weeks.from_now(from)
    assert_empty Activity.where(date: to)
    Activity.copy!(from, to)
    assert_equal Activity.where(date: from).count, Activity.where(date: to).count
  end

  # ::find_with_registration_student_and_teacher

  test "eager loads an activity's registration, student and teacher" do
    activity = Activity.find_with_registration_student_and_teacher(activities(:tuesday_activity).id)
    assert activity.association(:registrations).loaded?
    assert activity.registrations.first.association(:student).loaded?
    assert activity.registrations.first.association(:teacher).loaded?
  end

end
