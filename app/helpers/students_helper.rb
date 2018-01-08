module StudentsHelper

  def link_to_previous_week_for_student(student, date)
    link_to 'Previous week', student_path(student, date: date.prev_week), class: 'btn btn-outline-secondary'
  end

  def link_to_next_week_for_student(student, date)
    link_to 'Next week', student_path(student, date: date.next_week), class: 'btn btn-outline-primary float-right'
  end

end
