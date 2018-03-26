class Teacher < ApplicationRecord

  enum title: ['Miss', 'Mr.', 'Mrs.', 'Ms.']

  validates_presence_of :name
  validates_presence_of :title
  validates :name, uniqueness: { scope: :title, case_sensitive: false }
  validates :active, inclusion: { in: [true, false] }

  has_many :students, class_name: 'User', dependent: :restrict_with_exception

  def deactivate!
    transaction do
      self.active = false
      save!
      students.each do |s|
        s.teacher_id = nil
        s.save!(validate: false)
      end
    end
  end

  def to_s
    "#{title} #{name}"
  end

  def to_s_was
    "#{title_was} #{name_was}"
  end

end
