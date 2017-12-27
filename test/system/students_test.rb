require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  test 'student views their own profile' do
    student = users(:student)
    sign_in student
    visit student_path(student)
    assert_selector 'h2', text: student.to_s
  end

end
