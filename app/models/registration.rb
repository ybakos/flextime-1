class Registration < ApplicationRecord

  belongs_to :creator, class_name: 'User'
  belongs_to :student, class_name: 'User'
  belongs_to :teacher
  belongs_to :activity

  validates :activity, uniqueness: {scope: :student}
  validate :student_must_be_student
  validate :teacher_must_be_student_teacher
  validate :student_not_registered_for_another_activity_on_same_date, on: :create

  private

    def student_must_be_student
      errors.add(:student, 'must be a student') unless student.student?
    end

    def teacher_must_be_student_teacher
      errors.add(:teacher, 'must be student teacher') unless student&.teacher == teacher
    end

    def student_not_registered_for_another_activity_on_same_date
      if student.is_registered_for_activity_on?(activity.date)
        errors.add(:activity, 'has the same date as another registered activity')
      end
    end

end
