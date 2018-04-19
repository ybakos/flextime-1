class Registration < ApplicationRecord

  belongs_to :activity
  belongs_to :creator, class_name: 'User'
  belongs_to :student, class_name: 'User'
  belongs_to :teacher

  validates :activity, uniqueness: {scope: :student}
  validate :student_must_be_student
  validate :student_not_registered_for_another_activity_on_same_date, unless: :updating_activity
  validates_presence_of :teacher
  validate :teacher_must_be_student_teacher
  validate :activity_cannot_be_full, if: Proc.new { |r| r.activity_id_changed? }
  validate :activity_must_not_be_more_than_a_week_away, if: Proc.new { |r| r.creator.student? }
  validate :student_can_only_register_themselves, if: Proc.new { |r| r.creator.student? }


  def self.for_week(date)
    {
      date.tuesday => Registration.includes(:activity).where('activities.date = ?', date.tuesday).references(:activities).first,
      date.thursday => Registration.includes(:activity).where('activities.date = ?', date.thursday).references(:activities).first,
      date.friday => Registration.includes(:activity).where('activities.date = ?', date.friday).references(:activities).first
    }
  end

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
      current_registrations = student.registrations.includes(:activity).where('activities.date = ?', activity.date).references(:activities)
      if current_registrations.any? && current_registrations.first.activity != activity
        errors.add(:activity, 'has the same date as another registered activity')
      end
    end

    def activity_cannot_be_full
      return if activity.nil? || !activity.full?
      errors.add(:activity, 'is full')
    end

    def updating_activity
      !new_record? && activity_id_changed?
    end

    def activity_must_not_be_more_than_a_week_away
      if (activity.date - Date.today).to_i > 7
        errors.add(:activity, 'cannot be over a week in the future')
      end
    end

    def student_can_only_register_themselves
      errors.add(:student, 'can only register themselves') if student.id != creator.id
    end

end
