require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  def sign_in_as_student_and_visit_profile
    sign_in users(:student)
    visit student_path(users(:student))
  end

  test 'student views their own profile' do
    sign_in_as_student_and_visit_profile
    assert_selector 'h2', text: users(:student).to_s
  end

  test 'student views their Falcon Time for the current week' do
    sign_in_as_student_and_visit_profile
    within('#tuesday') { assert_selector 'h5', text: 'Fake Tuesday Activity' }
    within('#thursday') { assert_selector 'h5', text: 'Fake Thursday Activity' }
  end

  test 'student views their Falcon Time for the previous week' do
    sign_in_as_student_and_visit_profile
    skip
  end

  test 'student views their Falcon Time for the next week' do
    sign_in_as_student_and_visit_profile
    skip
  end

  test 'student sees current home room teacher' do
    sign_in_as_student_and_visit_profile
    assert has_select?('student_teacher_id', selected: users(:student).teacher.to_s)
  end

  test 'student specifies a teacher' do
    sign_in_as_student_and_visit_profile
    select 'Mr. Valid', from: 'student_teacher_id'
    click_button 'Ok'
    assert_text 'Student was successfully updated'
    assert_selector 'h2', text: users(:student).to_s
  end

  test 'student sees an error when specifying no teacher' do
    sign_in_as_student_and_visit_profile
    select 'Choose...', from: 'student_teacher_id'
    click_button 'Ok'
    assert_text 'Please specify a teacher'
    assert has_select?('student_teacher_id', selected: users(:student).teacher.to_s)
  end

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
    skip
  end

  test 'student should not be able to register for activities more than one week in advance' do
    skip
  end

end
