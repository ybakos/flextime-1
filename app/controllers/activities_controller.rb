class ActivitiesController < ApplicationController

  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @week_offset = params[:week_offset]&.to_i || 0
    day_offset = @week_offset * 7
    @activities = [
      Activity.where(date: Date.today.monday + 1 + day_offset),
      Activity.where(date: Date.today.monday + 3 + day_offset),
      Activity.where(date: Date.today.monday + 4 + day_offset)
    ]
  end

  def show; end

  def new
    @activity = Activity.new
    @dates = [Date.today + 1, Date.today + 3, Date.today + 4]
  end

  def edit; end

  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_activity
      @activity = Activity.find(params[:id])
    end


    def activity_params
      params.require(:activity).permit(:name, :room, :capacity, :date)
    end

end
