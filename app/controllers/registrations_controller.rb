class RegistrationsController < ApplicationController

  skip_before_action :restrict_from_students, only: :create
  before_action :set_registration, only: [:edit, :update, :destroy, :mark_attendance]
  before_action :check_student_id, only: :create

  def create
    student = User.student.where("id = ?", params[:student_id].to_i).first
    if student.teacher.nil?
      redirect_back(fallback_location: student_path(student), alert: "Please choose a #{Rails.application.config.app_name} teacher.")
      return
    end
    begin
      activity = Activity.find(params[:registration][:activity_id].to_i)
    rescue ActiveRecord::RecordNotFound
      redirect_to student_path(student), alert: "The activity has been removed. Please choose a different activity."
      return
    end
    @registration = Registration.new(creator: current_user, student: student, teacher: student.teacher, activity: activity)
    respond_to do |format|
      if @registration.save
        format.html { redirect_back(fallback_location: student_path(@registration.student), notice: "Successfully registered for #{activity.name}.") }
        format.json { render :show, status: :created, location: @registration }
      else
        format.html { redirect_back(fallback_location: student_path(@registration.student)) }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @activities = Activity.available_on_date(@registration.activity.date)
    # Add the existing activity to the list, unless it is already in the list of
    # available activities.
    @activities.to_a << @registration.activity unless @activities.include?(@registration.activity)
  end

  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to student_path(@registration.student, date: @registration.activity.week_date), notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration }
      else
        format.html { redirect_back(fallback_location: student_path(@registration.student)) }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: student_path(@registration.student, date: @registration.activity.week_date), notice: "#{@registration.student} was removed from #{@registration.activity.name}.") }
      format.json { head :no_content }
    end
  end

  def mark_attendance
    @registration.attendance = params[:attendance]
    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration.activity, notice: 'Attendance marked.' }
      else
        format.html { redirect_to @regitration.activity, notice: "There was a problem marking this student's attendance." }
      end
    end
  end

  private

    def set_registration
      @registration = Registration.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to student_path(id: params[:student_id]), alert: "The registration seems to have been deleted. Please review the student's current activities and continue from there."
    end

    def registration_params
      params.require(:registration).permit(:activity_id)
    end

    def check_student_id
      if current_user.student? && params[:student_id]&.to_i != current_user.id
        redirect_back(fallback_location: student_path(current_user), alert: 'You may only register yourself for an activity.')
      end
    end

end
