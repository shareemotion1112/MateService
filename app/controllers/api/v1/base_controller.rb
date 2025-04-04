module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_user!

      private

      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end

      def render_not_found(message = "Resource not found")
        render_error(message, :not_found)
      end

      def render_unauthorized(message = "Unauthorized")
        render_error(message, :unauthorized)
      end
    end
  end
end
