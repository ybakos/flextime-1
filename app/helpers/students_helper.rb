module StudentsHelper

  def link_to_previous_week_for_student(student, date)
    link_to 'Previous week', student_path(student, date: date.prev_week), class: 'btn btn-outline-secondary'
  end

  def link_to_next_week_for_student(student, date)
    link_to 'Next week', student_path(student, date: date.next_week), class: 'btn btn-outline-primary float-right'
  end

  def links_to_student_lists_by_last_name(date)
    ('A'..'Z').map do |letter|
      link_to letter, students_path(last_name_starting_with: letter, date: date)
    end
  end

end
