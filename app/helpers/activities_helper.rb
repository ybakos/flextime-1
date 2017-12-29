module ActivitiesHelper

  def week_header(date)
    date.current_week? ? 'This Week' : "Week of #{date.beginning_of_week.to_s(:long)}"
  end

  def link_to_previous_week(date)
    link_to 'Previous week', activities_path(date: date.prev_week), class: 'btn btn-outline-secondary'
  end

  def link_to_next_week(date)
    link_to 'Next week', activities_path(date: date.next_week), class: 'btn btn-outline-primary float-right'
  end

end
