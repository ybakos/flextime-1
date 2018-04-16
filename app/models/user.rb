class User < ApplicationRecord

  devise :database_authenticatable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: [:student, :staff, :admin]
  attribute :role, :integer, default: :student

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates :active, inclusion: { in: [true, false] }

  belongs_to :teacher, optional: true
  validates_presence_of :teacher_id, unless: Proc.new { |u| u.new_record? || !u.student? }

  has_many :registrations, foreign_key: :student_id
  has_many :created_registrations, foreign_key: :creator_id

  has_many :activities, through: :registrations

  default_scope { order(:last_name) }
  scope :active, -> { where(active: true) }
  scope :deactivated, -> { where(active: false) }
  scope :starting_with, ->(letter) { where('last_name LIKE ?', "#{letter}%") }

  # https://github.com/zquestz/omniauth-google-oauth2
  def self.from_omniauth(auth, allowed_domains)
    return unless allowed_domains.include? auth&.extra&.raw_info&.hd
    where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.image_url = auth.info.image
    end
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def last_name_first_name
    "#{last_name}, #{first_name}"
  end

  def activity_for_day_of_week(day, date)
    activities.where(date: date.send(day)).first
  end

  def active_for_authentication?
    super && active?
  end

end
