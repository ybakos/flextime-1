class SysAdmin::SchoolsController < SysAdmin::SysAdminController

  def index
    @schools = School.all
  end

  def show; end
  def new; end
  def create; end
  def edit; end
  def update; end
  def destroy; end

end
