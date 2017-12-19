class Teacher < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :title
end
