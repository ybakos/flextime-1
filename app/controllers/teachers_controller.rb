class TeachersController < AuthenticatedController

  before_action :restrict_unless_admin, except: [:index, :show]
  before_action :set_teacher, only: [:show, :edit, :update, :activate, :deactivate, :destroy]
  before_action :set_date, only: [:show]

  def index
    @teacher = Teacher.new
    @teachers = params[:status] == 'deactivated' ? Teacher.deactivated : Teacher.active
  end

  def show; end

  def edit; end

  def create
    @teacher = Teacher.new(teacher_params)
    @teacher.school = current_user.school
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to teachers_path, notice: "#{@teacher} was successfully created." }
        format.json { render :show, status: :created, location: @teacher }
      else
        @teachers = Teacher.all
        format.html { render :index }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    respond_to do |format|
      if @teacher.activate!
        format.html { redirect_to teachers_path, notice: 'Teacher was successfully activated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :index, alert: 'This teacher could not be activated.' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def deactivate
    respond_to do |format|
      if @teacher.deactivate!
        format.html { redirect_to teachers_path, notice: 'Teacher was successfully deactivated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :index, alert: 'This teacher could not be deactivated.' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @teacher.destroy
        format.html { redirect_to teachers_path, notice: "#{@teacher.name} was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { render :index, alert: 'You cannot delete this teacher. But, you can deactivate the teacher.'}
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def set_date
      @date = if params[:date] =~ /^\d{4}-\d{2}-\d{2}$/
        params[:date].to_date
      else
        Date.today.beginning_of_week
      end
    end

    def teacher_params
      params.require(:teacher).permit(:name, :title)
    end

end
