class Activity < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :room
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_presence_of :date
  validate :date_must_be_tuesday_thursday_friday, unless: Proc.new { date.nil? }
  validates_uniqueness_of :room, scope: [:date, :name], case_sensitive: false

  def to_s
    "#{name} (#{room}) on #{I18n.l date, format: :complete}"
  end

  def to_s_was
    "#{name_was} (#{room_was}) on #{I18n.l date_was, format: :complete}"
  end

  private

    def date_must_be_tuesday_thursday_friday
      errors.add(:date, 'Must be a Tuesday, Thursday or Friday') unless ['Tuesday', 'Thursday', 'Friday'].include? date.day_name
    end

end
