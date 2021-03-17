class Activity < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :room
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_presence_of :date
  validate :date_must_be_valid_activity_day, unless: Proc.new { date.nil? }
  validates_uniqueness_of :room, scope: [:date, :name], case_sensitive: false

  has_many :registrations, dependent: :destroy

  acts_as_tenant :school

  def self.for_week(date)
    Week::ACTIVITY_DAYS.reduce({}) do |week, day|
      week[date.send(day)] = Activity.where(date: date.send(day)).order('name').to_a
      week
    end
  end

  def self.available_on_date(date)
    Activity.where('date = ?', date).to_a.delete_if(&:full?)
  end

  def self.copy!(from_date, to_date)
    Activity.where(date: from_date).each do |a|
      Activity.create!(name: a.name, room: a.room, capacity: a.capacity, date: to_date)
    end
  end

  def self.find_with_registration_student_and_teacher(id)
    includes(registrations: [:student, :teacher]).order('users.last_name').find(id)
  end

  def full?
    registrations.size >= capacity
  end

  def week_date
    date&.monday
  end

  def day_and_room
    "#{I18n.l(date, format: :without_year)} in #{room}"
  end

  def to_s
    "#{name} (#{room}) on #{I18n.l date, format: :complete}"
  end

  def to_s_was
    "#{name_was} (#{room_was}) on #{I18n.l date_was, format: :complete}"
  end

  private

    def date_must_be_valid_activity_day
      unless Week.to_string_array.include? date.day_name
        errors.add(:date, "Must be a #{Week.to_s}")
      end
    end

end
