class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :restrict_from_students
  skip_before_action :authenticate_user!, if: :devise_controller?
  skip_before_action :restrict_from_students, if: :devise_controller?

  private

    def restrict_from_students
      redirect_to(student_path(current_user), alert: 'Access denied.') if current_user.student?
    end

    def after_sign_in_path_for(resource)
      current_user.student? ? student_path(current_user) : activities_path
    end

    def after_sign_out_path_for(resource)
      new_user_session_path
    end

end
