class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates :user_id, presence: true
  validates :role_id, presence: true
  validates :role_id, uniqueness: { scope: :user_id }
end
