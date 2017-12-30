class Registration < ApplicationRecord

  belongs_to :creator, class_name: 'User'
  belongs_to :student, class_name: 'User'
  belongs_to :teacher
  belongs_to :activity

  validate :student_must_be_student
  validate :teacher_must_be_student_teacher

  validates :activity, uniqueness: {scope: :student}

  private

    def student_must_be_student
      errors.add(:student, 'must be a student') unless student.student?
    end

    def teacher_must_be_student_teacher
      errors.add(:teacher, 'must be student teacher') unless student&.teacher == teacher
    end

end
