class Teacher < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :title
  enum title: [:miss, :mr, :mrs, :ms]
end
