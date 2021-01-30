class Users::RegistrationsController < Devise::RegistrationsController

  prepend_before_action :check_captcha, only: [:create]
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  protected

  def check_captcha
    unless verify_recaptcha
      self.resource = User.new sign_up_params
      resource.validate
      respond_with_navigational(resource) { render :new }
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, school_attributes: [:name, :slug]])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
