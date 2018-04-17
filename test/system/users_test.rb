require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  test 'todo' do
    skip
  end

  # https://github.com/osu-cascades/falcon-time/issues/72
  test 'user who signs out, goes back, and POSTs is redirected to sign in' do
    skip
  end

end
