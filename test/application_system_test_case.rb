require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test
  # To enable delete links (via data-method attribute) w/o javascript.
  Capybara.register_driver :rack_test do |app|
    Capybara::RackTest::Driver.new(app, respect_data_method: true)
  end
end
