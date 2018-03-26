class Teacher < ApplicationRecord

  enum title: ['Miss', 'Mr.', 'Mrs.', 'Ms.']

  validates_presence_of :name
  validates_presence_of :title
  validates :name, uniqueness: { scope: :title, case_sensitive: false }
  validates :active, inclusion: { in: [true, false] }

  has_many :students, class_name: 'User', dependent: :restrict_with_exception

  def deactivate!
    self.active = false
    save!
  end

  def to_s
    "#{title} #{name}"
  end

  def to_s_was
    "#{title_was} #{name_was}"
  end

end
