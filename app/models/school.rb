class School < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_many :activities
  has_many :registrations
  has_many :users

end
