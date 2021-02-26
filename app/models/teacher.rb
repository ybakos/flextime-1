class Teacher < ApplicationRecord

  enum title: ['Miss', 'Mr.', 'Mrs.', 'Ms.']

  validates_presence_of :name
  validates_presence_of :title
  validates :name, uniqueness: { scope: :title, case_sensitive: false }
  validates :active, inclusion: { in: [true, false] }

  acts_as_tenant(:school)
  has_many :students, class_name: 'User', dependent: :restrict_with_error
  has_many :registrations, dependent: :restrict_with_error

  default_scope { order(:name) }
  scope :active, -> { where(active: true) }
  scope :deactivated, -> { where(active: false) }

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
