class Group < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :members, class_name: "User"

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Scopes
  scope :by_member, ->(user_id) { joins(:members).where(users: { id: user_id }) }
  scope :popular, -> { joins(:members).group(:id).order("COUNT(users.id) DESC") }

  # Methods
  def owner
    user
  end

  def member_count
    members.count
  end

  def add_member(user)
    members << user unless members.include?(user)
  end

  def remove_member(user)
    members.delete(user) if members.include?(user)
  end
end
