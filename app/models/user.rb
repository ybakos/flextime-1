class User < ApplicationRecord

  devise :database_authenticatable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: [:student, :staff, :admin]
  after_initialize :set_default_role

  validates_presence_of :first_name
  validates_presence_of :last_name

  belongs_to :teacher, optional: true
  validates_presence_of :teacher_id, unless: Proc.new { |u| u.new_record? || !u.student? }

  has_many :registrations, foreign_key: :student_id
  has_many :created_registrations, foreign_key: :creator_id

  has_many :activities, through: :registrations

  # https://github.com/zquestz/omniauth-google-oauth2
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
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

  def activity_for_day_of_week(day, date)
    activities.where(date: date.send(day)).first
  end

  private

    def set_default_role
      role = :student
    end

end
