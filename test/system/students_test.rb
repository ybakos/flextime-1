require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  def sign_in_as_student_and_visit_profile
    sign_in users(:student)
    visit student_path(users(:student))
  end

  # Viewing profile and schedule

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
    click_link 'Previous week'
    within('#tuesday') { assert_selector 'h5', text: 'Fake Previous Tuesday Activity' }
  end

  test 'student views their Falcon Time for the next week' do
    sign_in_as_student_and_visit_profile
    click_link 'Next week'
    within('#tuesday') { assert_selector 'h5', text: 'Fake Next Tuesday Activity' }
  end

  test 'student sees current Falcon Time teacher and not the form' do
    sign_in_as_student_and_visit_profile
    assert_no_selector('student_teacher_id')
    assert_selector('h3#falcon_time_teacher', text: users(:student).teacher.to_s)
  end

  # Specifying teacher

  test 'student specifies a teacher' do
    sign_in users(:new_student_without_teacher)
    visit student_path(users(:new_student_without_teacher))
    select 'Mr. Valid', from: 'student_teacher_id'
    click_button 'Ok'
    assert_text 'Falcon Time teacher set to Mr. Valid'
    assert_selector 'h2', text: users(:student).to_s
  end

  test 'student sees an error when specifying no teacher' do
    sign_in users(:new_student_without_teacher)
    visit student_path(users(:new_student_without_teacher))
    select 'Choose...', from: 'student_teacher_id'
    click_button 'Ok'
    assert_text 'Please specify a teacher'
    assert has_select?('student_teacher_id')
  end

  test 'admins should see a teacher form even if the student has a teacher' do
    sign_in users(:admin)
    visit student_path(users(:student))
    assert has_select?('student_teacher_id', selected: users(:student).teacher.to_s)
  end

end
