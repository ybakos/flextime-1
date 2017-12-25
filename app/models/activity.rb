class Activity < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :room
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_presence_of :date

  def to_s
    "#{name} (#{room}) on #{I18n.l date, format: :complete}"
  end

end
