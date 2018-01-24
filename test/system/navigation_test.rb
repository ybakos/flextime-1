require 'application_system_test_case'

class NavigationTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def staff_navigation_link_titles
    ['Schedule', 'Students', 'Teachers']
  end

  test 'unauthenticated user only sees sign in navigation link' do
    visit root_url
    assert_link 'Sign In'
    staff_navigation_link_titles.each { |title| refute_link(title) }
  end

  test 'admin sees all navigation links' do
    sign_in users(:admin)
    visit root_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| assert_link(title) }
  end

  test 'staff sees appropriate navigation links' do
    sign_in users(:staff)
    visit root_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| assert_link(title) }
  end

  test 'student only sees sign out navigation link' do
    sign_in users(:student)
    visit root_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| refute_link(title) }
  end

  test 'user with no role only sees sign out navigation link' do
    sign_in users(:unknown)
    visit root_url
    assert_link 'Sign Out'
    staff_navigation_link_titles.each { |title| refute_link(title) }
  end

end
