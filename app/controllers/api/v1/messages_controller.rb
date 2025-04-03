module Api
  module V1
    class MessagesController < BaseController
      def index
        @messages = Message.between_users(current_user.id, params[:user_id])
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(50)

        render json: {
          messages: @messages,
          meta: {
            total_pages: @messages.total_pages,
            current_page: @messages.current_page,
            total_count: @messages.total_count
          }
        }
      end

      def create
        @message = current_user.sent_messages.build(message_params)

        if @message.save
          render json: @message, status: :created
        else
          render_error(@message.errors.full_messages)
        end
      end

      def update
        @message = current_user.received_messages.find(params[:id])
        @message.mark_as_read!
        render json: @message
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      private

      def message_params
        params.require(:message).permit(:content, :receiver_id)
      end
    end
  end
end 