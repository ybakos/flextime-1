class SysAdmin::SysAdminController < ApplicationController
  before_action :restrict_unless_sys_admin

  private

    def restrict_unless_sys_admin
      redirect_to(root_url, alert: 'Access denied.') unless current_user.sys_admin?
    end

end
