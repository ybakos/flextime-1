class ApplicationController < ActionController::Base

  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_and_prompt_for_sign_in

  protected

    def redirect_and_prompt_for_sign_in
      redirect_to(new_user_session_path, alert: 'Please sign in.')
    end

  private

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

end
