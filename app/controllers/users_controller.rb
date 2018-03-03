class UsersController < ApplicationController

  before_filter :ignore_password_and_password_confirmation, only: :update

  def index

  end

  def show

  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  # https://github.com/plataformatec/devise/wiki/how-to:-manage-users-through-a-crud-interface
  def ignore_password_and_password_confirmation
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

end
