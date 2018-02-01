require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  def sign_in_as_student_and_visit_profile
    sign_in users(:student)
    visit student_path(users(:student))
  end

  # Student registering for activities

  test 'student registers for an activity' do
    sign_in_as_student_and_visit_profile
    assert_no_selector 'h5', text: 'Fake Friday Activity'
    within '#friday' do
      select 'Fake Friday Activity', from: 'registration_activity_id'
      click_button 'Sign Up'
    end
    assert_text 'Successfully registered for Fake Friday Activity'
    assert_selector 'h5', text: 'Fake Friday Activity'
  end

  test 'student should be able to register for activities one week in advance' do
    sign_in_as_student_and_visit_profile
    one_pm_thursday = DateTime.now.thursday.change({hour:13, min:0, sec: 0})
    travel_to one_pm_thursday do
      click_link 'Next week'
      within '#thursday' do
        select 'Fake Next Thursday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Fake Next Thursday Activity'
      assert_selector 'h5', text: 'Fake Next Thursday Activity'
    end
  end

  test 'student should not be able to register for activities more than one week in advance' do
    skip
  end

  test 'student cannot register for activities on past dates' do
    sign_in_as_student_and_visit_profile
    click_link 'Previous week'
    refute has_select?('registration_activity_id')
  end

end
