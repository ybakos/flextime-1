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
    skip
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
    skip
  end

end
