class Teacher < ApplicationRecord

  default_scope { order(:name) }
  scope :active, -> { where(active: true) }
  scope :deactivated, -> { where(active: false) }

  enum title: ['Miss', 'Mr.', 'Mrs.', 'Ms.']

  has_many :registrations, dependent: :restrict_with_error
  has_many :students, class_name: 'User', dependent: :restrict_with_error

  validates :active, inclusion: { in: [true, false] }
  validates_presence_of :name
  validates :name, uniqueness: { scope: :title, case_sensitive: false }
  validates_presence_of :title

  acts_as_tenant :school

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

  def activate!
    update(active: true)
  end

  def to_s
    "#{title} #{name}"
  end

  def to_s_was
    "#{title_was} #{name_was}"
  end

  def can_be_deleted?
    students.empty? && registrations.empty?
  end

  def name=(name)
    super(name&.strip)
  end

end
