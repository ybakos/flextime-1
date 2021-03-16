class User < ApplicationRecord

  devise :database_authenticatable, :trackable, :validatable, :registerable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  enum role: [:student, :staff, :admin, :sys_admin]
  attribute :role, :integer, default: :student

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates :active, inclusion: { in: [true, false] }

  belongs_to :teacher, optional: true
  validates_presence_of :teacher_id, unless: Proc.new { |u| u.new_record? || !u.student? || !u.active || u.active_changed?(from: false) }
  validate :school_of_teacher_matches, if: -> { teacher.present? }

  has_many :registrations, foreign_key: :student_id
  has_many :created_registrations, foreign_key: :creator_id

  has_many :activities, through: :registrations

  acts_as_tenant :school

  default_scope { order(:last_name) }
  scope :active, -> { where(active: true) }
  scope :deactivated, -> { where(active: false) }
  scope :starting_with, ->(letter) { where('upper(last_name) LIKE ?', "#{letter}%") }

  before_save :remove_teacher, if: Proc.new { |u| u.role_changed?(from: 'student') }

  accepts_nested_attributes_for :school

  # https://github.com/zquestz/omniauth-google-oauth2
  def self.from_omniauth(auth, allowed_domains)
    return unless allowed_domains.include? auth&.extra&.raw_info&.hd
    where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.email = auth.info.email
      user.first_name = auth.info.first_name.capitalize
      user.last_name = auth.info.last_name.capitalize
      user.image_url = auth.info.image
    end
  end

  def self.disassociate_all_from_teachers
    update_all(teacher_id: nil)
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

  def remove_teacher
    self.teacher = nil
  end

  private

    def school_of_teacher_matches
      errors.add(:student, 'does not have the same school as the teacher') if school != teacher.school
    end

end
