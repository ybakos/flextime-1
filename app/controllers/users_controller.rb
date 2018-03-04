class UsersController < ApplicationController

  before_action :restrict_unless_admin
  before_action :ignore_password_and_password_confirmation, only: :update

  def index
    @users = User.order(:last_name)
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to users_path, alert: 'You are restricted from changing your own status.'
      return
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
      else
        format.html { redirect_to users_path, alert: 'Failed to update user' }
      end
    end
  end

  private

    # https://github.com/plataformatec/devise/wiki/how-to:-manage-users-through-a-crud-interface
    def ignore_password_and_password_confirmation
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end

    def user_params
      params.require(:user).permit(:role, :active)
    end

end
