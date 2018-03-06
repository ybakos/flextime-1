class RegistrationsController < ApplicationController

  skip_before_action :restrict_from_students, only: :create
  before_action :set_registration, only: [:edit, :update, :destroy]

  def create
    student = User.student.where("id = ?", params[:student_id].to_i).first
    if student.teacher.nil?
      redirect_back(fallback_location: student_path(student), alert: 'Please choose a Falcon Time teacher.')
      return
    end
    activity = Activity.find(params[:registration][:activity_id].to_i)
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
    @activities = Activity.where('date = ?', @registration.activity.date)
  end

  def update
    respond_to do |format|
      byebug
      if @registration.update(registration_params)
        format.html { redirect_back(fallback_location: student_path(@registration.student), notice: 'Registration was successfully updated.') }
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
      format.html { redirect_back(fallback_location: student_path(@registration.student), notice: 'Registration was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

  private

    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:activity_id)
    end

end
