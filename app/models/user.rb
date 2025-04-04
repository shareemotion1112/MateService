class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  # 프로필 이미지 첨부
  has_one_attached :avatar

  # 관계 설정
  has_many :owned_projects, class_name: "Project", foreign_key: "user_id", dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :projects, through: :team_members
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy
  has_many :owned_groups, class_name: "Group", foreign_key: "user_id", dependent: :destroy

  # 역할과 기술 스택
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  # 이름과 사용자명 필수 입력
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "영문자, 숫자, 밑줄만 사용 가능합니다" }
  before_validation :set_default_username, on: :create

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.username = generate_unique_username(auth.info.email)
    end
  end

  private

  def set_default_username
    self.username ||= User.generate_unique_username(email) if email.present?
  end

  def self.generate_unique_username(email)
    base_username = email.split("@").first.gsub(/[^a-zA-Z0-9_]/, "_")
    username = base_username
    counter = 1

    while User.exists?(username: username)
      username = "#{base_username}_#{counter}"
      counter += 1
    end

    username
  end
end
