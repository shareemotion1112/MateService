class Project < ApplicationRecord
  belongs_to :user
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  has_and_belongs_to_many :skills

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true

  # Enums
  enum :status, [:idea, :planning, :development, :launched], default: :idea

  # Scopes
  scope :active, -> { where.not(status: :launched) }
  scope :by_status, ->(status) { where(status: status) }

  # Methods
  def owner
    user
  end

  def team_size
    team_members.count
  end
end
