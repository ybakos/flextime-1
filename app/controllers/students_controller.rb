class StudentsController < ApplicationController

  skip_before_action :restrict_from_students, only: [:show, :update]
  before_action :set_student, only: [:show, :update]
  before_action :set_date, only: [:index, :show]

  def index
    @students = User.student
  end

  def show
    @activities = @student.activities.for_week(@date)
    @week_of_activities = Activity.for_week(@date)
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_path(@student), notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: student_path(@student) }
      else
        format.html { redirect_to student_path(@student), alert: 'Please specify a teacher.' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_student
      @student = current_user&.student? ? current_user : User.find(params[:id])
    end

    def set_date
      @date = if params[:date] =~ /^\d{4}-\d{2}-\d{2}$/
        params[:date].to_date
      else
        Date.today.beginning_of_week
      end
    end


    def student_params
      params.require(:student).permit(:teacher_id)
    end

end
