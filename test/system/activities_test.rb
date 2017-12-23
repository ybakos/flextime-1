require "application_system_test_case"

class ActivitiesTest < ApplicationSystemTestCase

  setup do
    visit activities_url
  end

  test 'staff views a list of activites for the current week' do
    assert_selector 'h4', text: (Date.today.monday + 1).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Tuesday Activity'
    assert_selector 'h4', text: (Date.today.monday + 3).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Thursday Activity'
    assert_selector 'h4', text: (Date.today.monday + 4).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Friday Activity'
  end

  test 'staff views a list of activities for the previous week' do
    visit activities_url(week_offset: -1)
    assert_selector 'h4', text: (Date.today.monday - 6).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Tuesday Activity'
    assert_selector 'h4', text: (Date.today.monday - 4).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Thursday Activity'
    assert_selector 'h4', text: (Date.today.monday - 3).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Friday Activity'
  end

  test 'staff views a list of activities for next week' do
    visit activities_url(week_offset: 1)
    assert_selector 'h4', text: (Date.today.monday + 8).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Tuesday Activity'
    assert_selector 'h4', text: (Date.today.monday + 10).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Thursday Activity'
    assert_selector 'h4', text: (Date.today.monday + 11).strftime("%B %e")
    assert_selector 'h5', text: 'Fake Friday Activity'
  end


end
