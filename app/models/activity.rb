class Activity < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :room
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_presence_of :date

  def humanized_date
    I18n.l date, format: :complete
  end

  def humanized_date=(yy_mm_dd)
    self.date = yy_mm_dd.to_s
  end

  def to_s
    "#{name} (#{room}) on #{I18n.l date, format: :complete}"
  end

end
