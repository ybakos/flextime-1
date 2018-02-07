module TeachersHelper

  def link_to_previous_week_for_teacher(teacher, date)
    link_to 'Previous week', teacher_path(teacher, date: date.prev_week), class: 'btn btn-outline-secondary'
  end

  def link_to_next_week_for_teacher(teacher, date)
    link_to 'Next week', teacher_path(teacher, date: date.next_week), class: 'btn btn-outline-primary float-right'
  end

end
