class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :user_id, presence: true
  validates :skill_id, presence: true
  validates :skill_id, uniqueness: { scope: :user_id }
end
