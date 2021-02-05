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

  test 'sys_admin creates a new school with invalid attributes' do
    sign_in(users(:sys_admin))
    visit new_sys_admin_school_path
    click_on 'Create School'
    assert_text 'error'
  end

  test 'sys_admin creates a new school with valid attributes' do
    sign_in(users(:sys_admin))
    visit new_sys_admin_school_path
    fill_in 'Name', with: 'Fake School Name'
    fill_in 'Slug', with: 'fakeschoolslug'
    click_on 'Create School'
    assert_text 'has been created'
  end

  test 'sys_admin edits a school' do
    sign_in(users(:sys_admin))
    new_name = 'New Fake School Name'
    visit edit_sys_admin_school_path(schools(:first))
    fill_in 'Name', with: new_name
    click_on 'Update School'
    assert_text 'School updated'
    assert_text new_name
  end

  test 'sys_admin tries to delete a school with delete-restricted associations' do
    sign_in(users(:sys_admin))
    visit sys_admin_school_path(schools(:first))
    click_on 'Delete'
    assert_text 'Cannot delete'
    assert_text schools(:first).name
  end

  test 'sys_admin deletes a school without any delete-restricted associations' do
    sign_in(users(:sys_admin))
    visit sys_admin_school_path(schools(:standalone_school))
    click_on 'Delete'
    assert_text 'School deleted'
    refute_text schools(:standalone_school).name
  end

end
