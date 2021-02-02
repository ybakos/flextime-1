require 'test_helper'

class SysAdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert defines_before_filter?(SysAdmin::SysAdminController, :authenticate_user!)
  end

  test 'requires a sys_admin user' do
    assert(defines_before_filter?(SysAdmin::SysAdminController, :restrict_unless_sys_admin))
  end

end
