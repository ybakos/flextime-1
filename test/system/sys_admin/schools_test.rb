require 'application_system_test_case'

class SysAdminViewsSchoolsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  test 'sys_admin views list of schools' do
    school = schools(:first)
    sign_in(users(:sys_admin))
    visit sys_admin_schools_path
    assert_text school.name
  end

  test 'sys_admin views a school' do
    school = schools(:first)
    sign_in(users(:sys_admin))
    visit sys_admin_school_path(school)
    assert_text school.name
  end

end
