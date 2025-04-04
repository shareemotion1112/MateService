class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  # Validations
  validates :content, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validate :sender_cannot_be_receiver

  # Scopes
  scope :unread, -> { where(read_at: nil) }
  scope :between_users, ->(user1_id, user2_id) {
    where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
          user1_id, user2_id, user2_id, user1_id)
  }

  # Callbacks
  after_create_commit :broadcast_message

  # Methods
  def mark_as_read!
    update(read_at: Time.current) if read_at.nil?
  end

  private

  def sender_cannot_be_receiver
    if sender_id == receiver_id
      errors.add(:receiver_id, "can't be the same as sender")
    end
  end

  def broadcast_message
    ActionCable.server.broadcast "chat_#{[ sender_id, receiver_id ].sort.join('_')}", {
      message: self,
      sender: sender,
      receiver: receiver
    }
  end
end
