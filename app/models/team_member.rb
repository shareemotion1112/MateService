class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :project

  # Validations
  validates :user_id, presence: true
  validates :project_id, presence: true
  validates :role, presence: true
  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :project_id, message: "is already a member of this project" }

  # Enums
  enum :role, {
    founder: 0,
    co_founder: 1,
    developer: 2,
    designer: 3,
    planner: 4,
    marketer: 5,
    other: 6,
    advisor: 7,
    investor: 8
  }, prefix: true

  enum :status, {
    pending: 0,
    active: 1,
    inactive: 2
  }, prefix: true

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :by_role, ->(role) { where(role: role) }
end
