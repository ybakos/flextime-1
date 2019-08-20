class StudentsController < ApplicationController

  skip_before_action :restrict_from_students, only: [:show, :update]
  before_action :set_student, only: [:show, :update]
  before_action :set_date, only: [:index, :show]

  def index
    @filter_params = params.slice(:all, :last_name_starting_with).permit!
    if params[:all]
      @students = User.student.active
    else
      initial_letter_of_last_name = params[:last_name_starting_with] || 'A'
      @students = User.student.active.starting_with(initial_letter_of_last_name).includes(:teacher)
    end
  end

  def show
    @registrations = @student.registrations.for_week(@date)
    @week_of_activities = available_activities_for_week
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_path(@student), notice: "#{Rails.application.config.app_name} teacher set to #{@student.teacher}" }
        format.json { render :show, status: :ok, location: student_path(@student) }
      else
        format.html { redirect_to student_path(@student), alert: 'Please specify a teacher.' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_teachers
    User.disassociate_all_from_teachers
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: "All students have been removed from teacher rosters." }
      format.json { render :show, status: :ok, location: student_path(@student) }
    end
  end

  private

    def set_student
      @student = current_user&.student? ? current_user : User.student.find(params[:id])
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

    def available_activities_for_week
      activities_for_week = Activity.for_week(@date)
      activities_for_week.each do |date, activities|
        activities.delete_if(&:full?)
      end
      activities_for_week
    end

end
