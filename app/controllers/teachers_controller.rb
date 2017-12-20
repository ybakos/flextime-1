class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

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

  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: "#{@teacher} was successfully removed." }
      format.json { head :no_content }
    end
  end

  private

    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def teacher_params
      params.require(:teacher).permit(:name, :title)
    end

end
