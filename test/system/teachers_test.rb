require "application_system_test_case"

class TeachersTest < ApplicationSystemTestCase

  test 'staff views a list of teachers' do
    visit teachers_url
    assert_selector 'h2', text: 'Teachers'
    assert_link 'Miss Valid'
  end

end
