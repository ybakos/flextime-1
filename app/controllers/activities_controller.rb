class ActivitiesController < ApplicationController

  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_date, only: [:index]

  def index
    @activities = {
      @date.tuesday => Activity.where(date: @date.tuesday),
      @date.thursday => Activity.where(date: @date.thursday),
      @date.friday => Activity.where(date: @date.friday)
    }
  end

  def show; end

  def new
    @activity = Activity.new(date: params[:date])
    @dates = [
      [I18n.l(@activity.date.monday + 1, format: :complete), @activity.date.monday + 1],
      [I18n.l(@activity.date.monday + 3, format: :complete), @activity.date.monday + 3],
      [I18n.l(@activity.date.monday + 4, format: :complete), @activity.date.monday + 4]
    ]
  end

  def edit
    @dates = [
      [I18n.l(@activity.date.monday + 1, format: :complete), @activity.date.monday + 1],
      [I18n.l(@activity.date.monday + 3, format: :complete), @activity.date.monday + 3],
      [I18n.l(@activity.date.monday + 4, format: :complete), @activity.date.monday + 4]
    ]
  end

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

    def set_date
      @date = if params[:date] =~ /^\d{4}-\d{2}-\d{2}$/
        params[:date].to_date.beginning_of_week
      else
        Date.today.beginning_of_week
      end
    end

    def activity_params
      params.require(:activity).permit(:name, :room, :capacity, :date)
    end

end
