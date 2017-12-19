class Teacher < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :title
  enum title: ['Miss', 'Mr.', 'Mrs.', 'Ms.']

  def to_s
    "#{title} #{name}"
  end

end
