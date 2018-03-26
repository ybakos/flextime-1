class TeachersController < ApplicationController

  before_action :set_teacher, only: [:show, :edit, :update, :deactivate]
  before_action :set_date, only: [:show]

  def index
    @teacher = Teacher.new
    @teachers = Teacher.order(:name)
  end

  def show; end

  def edit; end

  def create
    @teacher = Teacher.new(teacher_params)
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

  def deactivate
    respond_to do |format|
      if @teacher.deactivate!
        format.html { redirect_to teachers_path, notice: 'Teacher was successfully deactivated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :index }
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
