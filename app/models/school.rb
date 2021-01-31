class School < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_many :activities, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_many :users, dependent: :destroy

end
