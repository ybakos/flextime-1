class Registration < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :student, class_name: 'User'
  belongs_to :teacher
  belongs_to :activity
end
