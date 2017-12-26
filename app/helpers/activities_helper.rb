module ActivitiesHelper

  def week_header(date)
    date.current_week? ? 'This Week' : "Week of #{date.to_s(:long)}"
  end

end
