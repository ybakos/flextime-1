class StudentsController < ApplicationController

  skip_before_action :restrict_from_students, only: [:show, :update]
  before_action :set_student, only: [:show, :edit, :update]
  before_action :set_date, only: [:index, :show]

  def index
    @filter_params = params.slice(:all, :last_name_starting_with).permit!
    if params[:all]
      @students = User.includes(:teacher).student.active
    else
      initial_letter_of_last_name = params[:last_name_starting_with] || 'A'
      @students = User.includes(:teacher).student.active.starting_with(initial_letter_of_last_name)
    end
  end

  def show
    @registrations = @student.registrations.for_week(@date)
    @week_of_activities = available_activities_for_week(current_user.student?)
  end

  def edit
  end

  def update
    if updating_teacher?
      update_teacher
    elsif updating_name?
      update_name
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
      params.require(:student).permit(:teacher_id, :first_name, :last_name)
    end

    def available_activities_for_week(omit_restricted)
      activities_for_week = Activity.for_week(@date)
      activities_for_week.each do |date, activities|
        activities.delete_if { |a| a.full? || (omit_restricted && a.restricted?) }
      end
      activities_for_week
    end

    def updating_teacher?
      student_params.has_key?('teacher_id')
    end

    def updating_name?
      student_params.has_key?('first_name') || student_params.has_key?('last_name')
    end

    def update_teacher
      if @student.update(student_params)
        redirect_to student_path(@student), notice: "#{Rails.application.config.app_name} teacher set to #{@student.teacher}"
      else
        redirect_to student_path(@student), alert: 'Please specify a teacher.'
      end
    end

    def update_name
      if @student.update(student_params)
        redirect_to student_path(@student), notice: "#{@student.attribute_before_last_save(:first_name)} #{@student.attribute_before_last_save(:last_name)} changed to #{@student}."
      else
        render :edit
      end
    end

end
