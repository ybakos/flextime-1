class UsersController < AuthenticatedController

  before_action :restrict_unless_admin
  before_action :ignore_password_and_password_confirmation, only: :update

  def index
    @filter_params = params.slice(:status, :role, :last_name_starting_with).permit!
    if @filter_params.empty? then @users = User.all; return end
    finders = []
    if params[:status] == 'active'
      finders << :active
    elsif params[:status] == 'deactivated'
      finders << :deactivated
    end
    if params[:role] == 'student'
      finders << :student
    elsif params[:role] == 'staff'
      finders << :staff
    elsif params[:role] == 'admin'
      finders << :admin
    end
    if params[:last_name_starting_with]
      @users = finders.inject(User, :send).starting_with(params[:last_name_starting_with])
    else
      @users = finders.inject(User, :send)
    end
  end

  def update
    filter_params = params.slice(:status, :role, :last_name_starting_with).permit!
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to users_url(filter_params), alert: 'You are restricted from changing your own status.'
      return
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url(filter_params), notice: 'User was successfully updated.' }
      else
        format.html { redirect_to users_url(filter_params), alert: 'Failed to update user' }
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
