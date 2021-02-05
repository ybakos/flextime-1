class SysAdmin::SchoolsController < SysAdmin::SysAdminController

  def index
    @schools = School.all
  end

  def show
    @school = School.find(params[:id])
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      redirect_to sys_admin_schools_url, notice: "School #{@school} has been created."
    else
      render :new
    end
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    if @school.update(school_params)
      redirect_to sys_admin_school_url(@school), notice: "School updated."
    else
      render :edit
    end
  end

  def destroy
    @school = School.find(params[:id])
    @school.destroy!
    redirect_to sys_admin_schools_path, notice: "School deleted."
  rescue ActiveRecord::RecordNotDestroyed => error
    redirect_to sys_admin_school_path(@school), alert: error.record.errors.full_messages
  end

  private

    def school_params
      params.require(:school).permit(:name, :slug)
    end

end
