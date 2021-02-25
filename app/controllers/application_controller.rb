class ApplicationController < ActionController::Base

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :restrict_from_students, unless: :devise_controller?
  set_current_tenant_through_filter
  before_action :set_tenant


  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_and_prompt_for_sign_in

  protected

    def redirect_and_prompt_for_sign_in
      redirect_to(new_user_session_path, alert: 'Please sign in.')
    end

  private

    def restrict_from_students
      redirect_to(student_path(current_user), alert: 'Access denied.') if current_user.student?
    end

    def restrict_unless_admin
      redirect_to(activities_url, alert: 'Access denied.') unless current_user.admin?
    end

    def after_sign_in_path_for(resource)
      if resource.student?
        student_path(resource)
      else
        activities_path
      end
    end

    def after_sign_out_path_for(resource)
      new_user_session_path
    end

    def set_tenant
      current_user&.school
    end

end
