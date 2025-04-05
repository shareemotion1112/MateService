class Project < ApplicationRecord
  belongs_to :user
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  has_and_belongs_to_many :skills

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :required_skills, presence: true

  # Enums
  enum :status, [ :recruiting, :in_progress, :completed ], default: :recruiting

  # Scopes
  scope :active, -> { where(status: :recruiting) }
  scope :by_status, ->(status) { where(status: status) }

  # Methods
  def owner
    user
  end

  def team_size
    team_members.count
  end

  def can_apply?(user)
    status == "recruiting" && user != self.user && !team_members.exists?(user: user)
  end

  def image_url
    @image_url ||= begin
      return nil unless image_path.present?
      supa = SupabaseClient.instance
      { 
        url: supa.storage.from('projects').create_signed_url(image_path, 3600),
        public_url: supa.storage.from('projects').get_public_url(image_path)
      }
    end
  end
end
