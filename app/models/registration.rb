class Registration < ApplicationRecord

  belongs_to :activity
  belongs_to :creator, class_name: 'User'
  belongs_to :student, class_name: 'User'
  belongs_to :teacher

  validates :activity, uniqueness: {scope: :student}
  validate :student_must_be_student
  validate :student_not_registered_for_another_activity_on_same_date
  validates_presence_of :teacher
  validate :teacher_must_be_student_teacher

  private

    def student_must_be_student
      errors.add(:student, 'must be a student') unless student&.student?
    end

    def teacher_must_be_student_teacher
      if student.nil? || student.teacher != teacher
        errors.add(:teacher, 'must be student teacher')
      end
    end

    def student_not_registered_for_another_activity_on_same_date
      activities = student&.activities&.where('date = ?', activity&.date)&.includes(:registrations)
      return if activities.nil? || activities&.empty? || (activities&.length == 1 && activities&.first.registrations.length == 1 && activities.first.registrations.first.id == id)
      errors.add(:activity, 'has the same date as another registered activity')
    end

end
