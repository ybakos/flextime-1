require "application_system_test_case"

class ActivitiesTest < ApplicationSystemTestCase

  setup do
    visit activities_url
  end

  test 'staff views a list of activites for the current week' do
    d = Date.today
    assert_selector 'h2', text: 'This Week'
    [d.tuesday, d.thursday, d.friday].each do |day|
      assert_selector 'h4', text: day.strftime("%B %-e")
      assert_selector 'h5', text: "Fake #{day.day_name} Activity"
    end
  end

  test 'staff views a list of activities for the previous week' do
    d = Date.today.prev_week
    click_link 'Previous week'
    assert_selector 'h2', text: "Week of #{d.to_s(:long)}"
    [d.tuesday, d.thursday, d.friday].each do |day|
      assert_selector 'h4', text: day.strftime("%B %-e")
      assert_selector 'h5', text: "Fake Previous #{day.day_name} Activity"
    end
  end

  test 'staff views a list of activities for next week' do
    d = Date.today.next_week
    click_link 'Next week'
    assert_selector 'h2', text: "Week of #{d.to_s(:long)}"
    [d.tuesday, d.thursday, d.friday].each do |day|
      assert_selector 'h4', text: day.strftime("%B %-e")
      assert_selector 'h5', text: "Fake Next #{day.day_name} Activity"
    end
  end

  # https://github.com/osu-cascades/falcon-time/issues/30
  test 'staff views a week with no activities' do
    2.times { click_link 'Previous week' }
    d = Date.today.prev_week.prev_week
    assert_selector 'h4', text: d.tuesday.strftime("%B %-e")
    assert_no_selector 'h5'
  end

  test 'staff creates a new activity' do
    date_text = I18n.l(Date.today.tuesday, format: :without_year)
    activity_name = 'New Fake Tuesday Activity'
    activity_room = 'New Fake Room'
    first('a', text: 'Add New Activity').click
    assert_selector 'h2', text: 'New Activity'
    fill_in 'activity_name', with: activity_name
    fill_in 'activity_room', with: 'New Fake Room'
    fill_in 'activity_capacity', with: 10
    select date_text, from: 'activity_date'
    click_button 'Create Activity'
    assert_text 'Activity was successfully created'
    assert_selector 'h2', text: activity_name
    assert_selector 'h3', text: "#{date_text} in #{activity_room}"
  end

end
