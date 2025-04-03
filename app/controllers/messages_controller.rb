class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_user, only: [:chat]

  def index
    @messages = current_user.received_messages
                          .includes(:sender)
                          .order(created_at: :desc)
                          .group_by(&:sender_id)
  end

  def show
    @message = Message.find(params[:id])
    @message.mark_as_read! if @message.receiver == current_user
  end

  def new
    @message = Message.new
    @message.receiver_id = params[:receiver_id] if params[:receiver_id]
  end

  def create
    @message = current_user.sent_messages.build(message_params)

    if @message.save
      redirect_to chat_messages_path(user_id: @message.receiver_id), notice: 'Message was sent successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def chat
    @messages = Message.between_users(current_user.id, @chat_user.id)
                      .order(created_at: :asc)
                      .includes(:sender, :receiver)
    
    @messages.where(receiver: current_user).update_all(read_at: Time.current)
    @message = Message.new(receiver: @chat_user)
  end

  private

  def set_chat_user
    @chat_user = User.find(params[:user_id])
  end

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end 