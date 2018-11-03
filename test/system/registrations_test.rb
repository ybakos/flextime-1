# Registration Tests
# The fixtures create the following activities and registrations.
# It's important to travel_to Date.today.monday, as the fixtures
# for activities have particular dates.
# See registrations, activities, teachers, and users fixtures.
#
# Activities
# ----------
# T  R  F    T  R  F    T  R  F
# a  b  c    d  f  h    i  j  k
#            e  g
#
# Registrations
# -------------
# T  R  F    T  R  F    T  R  F
# a          d  g       i
#
require 'application_system_test_case'

class RegistrationsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  def sign_in_as_student_and_visit_profile
    sign_in users(:student)
    visit student_path(users(:student))
  end

  # Staff registers student for activities

  test 'staff registers a student for an activity' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      assert_no_selector 'h5', text: 'Fake Friday Activity'
      within '#friday' do
        select 'Fake Friday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Fake Friday Activity'
      assert_selector 'h5', text: 'Fake Friday Activity'
    end
  end

  test 'staff cannot register student for activities that are full' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:second_student))
      within '#thursday' do
        assert has_select?('registration_activity_id')
        refute has_select?('registration_activity_id', with_options: ['Second Fake Thursday Activity'])
      end
    end
  end

  test 'staff cannot register student for activities that are full when editing a student\'s existing registration' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:second_student))
      within '#tuesday' do
        select 'Second Fake Tuesday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Second Fake Tuesday Activity'
      click_link 'change'
      refute_select('registration_activity_id', with_options: ['Fake Tuesday Activity'], exact: true)
    end
  end

  test 'staff can register student for activities more than one week in advance' do
    travel_to Date.today.wednesday do
      sign_in users(:staff)
      visit student_path(users(:student))
      click_link 'Next week'
      within '#thursday' do
        assert has_select?('registration_activity_id')
      end
      within '#friday' do
        assert has_select?('registration_activity_id')
      end
    end
  end


  # Student registering for activities

  test 'student registers for an activity' do
    travel_to Date.today.monday do
      sign_in_as_student_and_visit_profile
      assert_no_selector 'h5', text: 'Fake Friday Activity'
      within '#friday' do
        select 'Fake Friday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Fake Friday Activity'
      assert_selector 'h5', text: 'Fake Friday Activity'
    end
  end

  test 'student can register for activities up to 1pm the day of' do
    skip
  end

  test 'student can notregister for activities after 1pm the day of' do
    skip
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
    travel_to Date.today.wednesday do
      sign_in_as_student_and_visit_profile
      click_link 'Next week'
      within '#thursday' do
        refute has_select?('registration_activity_id')
      end
      within '#friday' do
        refute has_select?('registration_activity_id')
      end
    end
  end

  test 'student cannot register for activities on past dates' do
    travel_to Date.today.monday do
      sign_in_as_student_and_visit_profile
      click_link 'Previous week'
      refute has_select?('registration_activity_id')
    end
  end

  test 'student cannot register for activities that are full' do
    travel_to Date.today.monday do
      sign_in users(:second_student)
      visit student_path(users(:second_student))
      within '#thursday' do
        assert has_select?('registration_activity_id')
        refute has_select?('registration_activity_id', with_options: ['Second Fake Thursday Activity'])
      end
    end
  end

  test 'student does not see edit or remove links' do
    travel_to Date.today.monday do
      sign_in users(:student)
      visit student_path(users(:student))
      assert_selector 'h5', text: 'Fake Tuesday Activity'
      assert_selector 'h5', text: 'Fake Thursday Activity'
      assert_no_link 'edit'
      assert_no_link 'remove'
    end
  end


  # Staff viewing lists of student registrations

  # /students

  test 'staff can view list of all student registrations for the current week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit students_path(all: true)
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.teacher') { assert_text 'Valid' }
        within('.tuesday') { assert_text 'Fake Tuesday Activity' }
        within('.thursday') { assert_text 'Second Fake Thursday Activity' }
        assert find('.friday').text == ''
      end
    end
  end

  test 'staff can view list of all student registrations for the previous week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit students_path
      click_link 'Previous week'
      click_link('All')
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.teacher') { assert_text 'Valid' }
        within('.tuesday') { assert_text 'Fake Previous Tuesday Activity' }
        assert find('.thursday').text == ''
        assert find('.friday').text == ''
      end
    end
  end

  test 'staff can view list of all student registrations for the next week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit students_path
      click_link 'Next week'
      click_link('All')
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.teacher') { assert_text 'Valid' }
        within('.tuesday') { assert_text 'Fake Next Tuesday Activity' }
        assert find('.thursday').text == ''
        assert find('.friday').text == ''
      end
    end
  end

  test 'staff does not see deactivated students' do
    sign_in users(:staff)
    visit students_path
    click_link 'All'
    refute_text 'Student, Fake Deactivated'
  end

  # /students/:id

  test 'staff can view list of specific student registrations for the current week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      within('#tuesday') { assert_selector 'h5', text: 'Fake Tuesday Activity' }
      within('#thursday') { assert_selector 'h5', text: 'Second Fake Thursday Activity' }
    end
  end

  test 'staff can view list of specific student registrations for the previous week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      click_link 'Previous week'
      within('#tuesday') { assert_selector 'h5', text: 'Fake Previous Tuesday Activity' }
    end
  end

  test 'staff can view list of specific student registrations for the next week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      click_link 'Next week'
      within('#tuesday') { assert_selector 'h5', text: 'Fake Next Tuesday Activity' }
    end
  end

  # /teachers/:id

  test "staff can view list of a teacher's students' registrations for the current week" do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit teacher_path(teachers(:miss_valid))
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.tuesday') { assert_text 'Fake Tuesday Activity' }
        within('.thursday') { assert_text 'Second Fake Thursday Activity' }
        assert find('.friday').text == ''
      end
    end
  end

  test "staff can view list of a teacher's students' registrations for the previous week" do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit teacher_path(teachers(:miss_valid))
      click_link 'Previous week'
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.tuesday') { assert_text 'Fake Previous Tuesday Activity' }
        assert find('.thursday').text == ''
        assert find('.friday').text == ''
      end
    end
  end

  test "staff can view list of a teacher's students' registrations for the next week" do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit teacher_path(teachers(:miss_valid))
      click_link 'Next week'
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.tuesday') { assert_text 'Fake Next Tuesday Activity' }
        assert find('.thursday').text == ''
        assert find('.friday').text == ''
      end
    end
  end

  test 'staff does not see deactivated students in teacher list' do
    sign_in users(:staff)
    visit teacher_path(teachers(:miss_valid))
    refute_text 'Student, Fake Deactivated'
  end

  # /activities/:id

  test 'staff can view list of student registrations for a specific activity' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit activity_path(activities(:tuesday_activity))
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Student, Fake' }
        within('.teacher') { assert_text 'Valid' }
      end
    end
  end

  # Staff editing student activities

  # /students/:id

  test 'staff can edit upcoming student registrations' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      within('#tuesday') { click_link('change') }
      select 'Second Fake Tuesday Activity', from: 'registration_activity_id'
      click_button 'Save'
      assert_text 'Registration was successfully updated'
      within '#tuesday' do
        assert_selector 'h5', text: 'Second Fake Tuesday Activity'
      end
    end
  end

  test 'staff can delete upcoming student registrations' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      within '#tuesday' do
        assert_selector 'h5', text: 'Fake Tuesday Activity'
        click_link('remove')
      end
      assert_text 'Fake Student was removed from Fake Tuesday Activity'
      within '#tuesday' do
        refute_selector 'h5', text: 'Fake Tuesday Activity'
        assert has_select?('registration_activity_id')
      end
    end
  end

  test 'no one can edit or update past student registrations' do
    skip
  end

end
