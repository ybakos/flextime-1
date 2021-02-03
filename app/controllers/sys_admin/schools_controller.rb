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

  def edit; end
  def update; end
  def destroy; end

  private

    def school_params
      params.require(:school).permit(:name, :slug)
    end

end
