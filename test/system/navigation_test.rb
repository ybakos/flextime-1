require 'application_system_test_case'

class NavigationTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def staff_navigation_link_titles
    ['Schedule', 'Students', 'Teachers']
  end

  test 'unauthenticated user only sees sign in and sign up navigation links' do
    visit root_url
    assert_link 'Sign In'
    assert_link 'Sign Up'
    staff_navigation_link_titles.each { |title| refute_link(title) }
  end

  test 'admin sees all navigation links' do
    sign_in users(:admin)
    visit activities_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| assert_link(title) }
  end

  test 'staff sees appropriate navigation links' do
    sign_in users(:staff)
    visit activities_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| assert_link(title) }
  end

  test 'student only sees sign out navigation link' do
    sign_in users(:student)
    visit activities_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| refute_link(title) }
  end

  test 'user with no role only sees sign out navigation link' do
    sign_in users(:unknown)
    visit activities_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| refute_link(title) }
  end

end
