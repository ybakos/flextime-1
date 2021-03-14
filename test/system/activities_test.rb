require 'application_system_test_case'

class ActivitiesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:staff)
    visit activities_url
  end

  # Viewing

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

  test 'staff views a single activity' do
    a = activities(:tuesday_activity)
    click_link a.name
    assert_selector 'h2', text: a.name
    assert_selector 'h3', text: "#{I18n.l(a.date, format: :without_year)} in #{a.room}"
  end

  # https://github.com/osu-cascades/flex-time/issues/117
  test 'staff can see restricted activities' do
    d = Date.today
    assert_selector 'h2', text: 'This Week'
    assert_selector 'h5', text: 'Restricted Activity'
    assert_text 'restricted'
  end

  # https://github.com/osu-cascades/flex-time/issues/117
  test 'staff views a restricted activity' do
    a = activities(:restricted)
    click_link a.name
    assert_selector 'h2', text: a.name
    assert_selector 'h3', text: 'Restricted'
  end

  # Creating

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

  # https://github.com/osu-cascades/flex-time/issues/117
  test 'staff creates a restricted activity' do
    date_text = I18n.l(Date.today.tuesday, format: :without_year)
    activity_name = 'New Fake Tuesday Activity'
    activity_room = 'New Fake Room'
    first('a', text: 'Add New Activity').click
    assert_selector 'h2', text: 'New Activity'
    fill_in 'activity_name', with: activity_name
    fill_in 'activity_room', with: 'New Fake Room'
    fill_in 'activity_capacity', with: 10
    select date_text, from: 'activity_date'
    check 'Restricted?'
    click_button 'Create Activity'
    assert_text 'Activity was successfully created'
    assert_selector 'h2', text: activity_name
    assert_selector 'h3', text: "#{date_text} in #{activity_room}"
    assert_selector 'h3', text: 'Restricted'
  end

  test 'staff creating a new activity sees appropriate date pre-selected' do
    d = Date.today
    [d.tuesday, d.thursday, d.friday].each do |day|
      visit new_activity_url(date: day.to_s)
      assert has_select?('activity_date', selected: I18n.l(day, format: :complete))
    end
    # No date parameter? Nothing pre-selected.
    # Note: May fail when not using rack_test driver.
    #       See https://github.com/teamcapybara/capybara/pull/1947.
    visit new_activity_url
    assert has_select?('activity_date', selected: [])
  end

  test 'staff sees an error when creating an activity and neither a name, room, or capacity' do
    visit new_activity_url
    click_button 'Create Activity'
    assert_text '3 errors prohibited this activity from being saved'
    assert_text "Name can't be blank"
    assert_text "Room can't be blank"
    assert_text 'Capacity is not a number'
  end

  test 'staff sees an error when creating an activity with a name, room and date matching an existing activity' do
    visit new_activity_url
    fill_in 'activity_name', with: activities(:tuesday_activity).name
    fill_in 'activity_room', with: activities(:tuesday_activity).room
    fill_in 'activity_capacity', with: 1
    select I18n.l(activities(:tuesday_activity).date, format: :without_year), from: 'activity_date'
    click_button 'Create Activity'
    assert_selector 'h2', text: 'New Activity'
    assert_text '1 error prohibited this activity from being saved'
    assert_text 'Room has already been taken'
  end

  test 'admins can copy all the activities from one day to the same day the following week' do
    sign_in users(:admin)
    visit activities_url
    click_link 'Next week'
    within '#thursday' do
      assert_selector 'h5', text: 'Fake Next Thursday Activity'
    end
    click_link 'Next week' # an empty week in the schedule
    click_link 'copy last Thursday'
    within '#thursday' do
      assert_selector 'h5', text: 'Fake Next Thursday Activity'
    end
  end

  # Updating

  def edit_activity
    click_link activities(:tuesday_activity).name
    click_link 'Edit'
    assert_selector 'h2', text: activities(:tuesday_activity).name
  end

  test 'staff updates an activity' do
    edit_activity
    fill_in 'activity_name', with: 'FAKE UPDATE'
    click_button 'Update Activity'
    assert_text 'Activity was successfully updated'
    assert_selector 'h2', text: 'FAKE UPDATE'
  end

  test 'staff sees an error when updating an activity and neither a name, room, or capacity are specified' do
    edit_activity
    fill_in 'activity_name', with: ''
    fill_in 'activity_room', with: ''
    fill_in 'activity_capacity', with: ''
    click_button 'Update Activity'
    assert_selector 'h2', text: activities(:tuesday_activity).name_was
    assert_text '3 errors prohibited this activity from being saved'
    assert_text "Name can't be blank"
    assert_text "Room can't be blank"
    assert_text 'Capacity is not a number'
  end

  test 'staff sees an error when updating an activity with a name, room and date matching an existing activity' do
    edit_activity
    fill_in 'activity_name', with: activities(:thursday_activity).name
    fill_in 'activity_room', with: activities(:thursday_activity).room
    fill_in 'activity_capacity', with: 1
    select I18n.l(activities(:thursday_activity).date, format: :without_year), from: 'activity_date'
    click_button 'Update Activity'
    assert_selector 'h2', text: activities(:tuesday_activity).name_was
    assert_text '1 error prohibited this activity from being saved'
    assert_text 'Room has already been taken'
  end

  # Delete

  test 'staff does not see delete link' do
    visit activity_url(activities(:tuesday_activity))
    assert_no_link 'Delete'
  end

  test 'admin deletes an activity' do
    sign_in users(:admin)
    visit activity_url(activities(:tuesday_activity))
    click_link 'Delete'
    assert_text 'Fake Tuesday Activity was successfully deleted'
  end

  # Multi-tenancy

  test 'staff does not see activities from other schools' do
    sign_in users(:second_staff)
    visit activities_url
    refute_text activities(:tuesday_activity).name
  end

  test 'staff cannot view an activity from another school' do
    sign_in users(:second_staff)
    other_scool_activity = activities(:tuesday_activity)
    visit activity_path(other_scool_activity)
    refute_text activities(:tuesday_activity).name
  end

  test 'a created activity for one school is not visible by staff at another school' do
    # From test 'staff creates a new activity'
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
    sign_in users(:second_staff)
    visit activities_path
    refute_text activity_name
  end

  test 'copy' do
    # From test 'admins can copy all the activities from one day to the same day the following week' do
    sign_in users(:admin)
    visit activities_url
    click_link 'Next week'
    click_link 'Next week' # an empty week in the schedule
    click_link 'copy last Thursday'
    sign_in users(:second_staff)
    visit activities_url
    click_link 'Next week'
    click_link 'Next week'
    refute_text 'Fake Next Thursday Activity'
  end

  test 'copying activities in one school should not cause a copying of activities of another school' do
    # From test 'admins can copy all the activities from one day to the same day the following week' do
    # Scenario: School 1 copying activities should not result in copying for School 2
    sign_in users(:admin)
    visit activities_url
    click_link 'Next week'
    click_link 'Next week' # an empty week in the schedule
    click_link 'copy last Thursday'
    sign_in users(:third_staff)
    visit activities_url
    click_link 'Next week'
    click_link 'Next week'
    refute_text 'Fake Third School Next Thursday Activity'
    # Scenario: School 2 copying activities should not result in copying for School 1
    sign_in users(:third_admin)
    visit activities_url
    click_link 'Next week'
    within '#thursday' do
      assert_selector 'h5', text: 'Fake Third School Next Thursday Activity'
    end
    click_link 'Next week' # an empty week in the schedule
    click_link 'copy last Thursday'
    within '#thursday' do
      assert_selector 'h5', text: 'Fake Third School Next Thursday Activity'
    end
    sign_in users(:admin)
    visit activities_url
    click_link 'Next week'
    click_link 'Next week'
    refute_text 'Third School'
  end

end
