module Api
  module V1
    class GroupsController < BaseController
      before_action :set_group, only: [:show, :update, :destroy, :join, :leave]

      def index
        @groups = Group.includes(:user, :members)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(20)

        render json: {
          groups: @groups,
          meta: {
            total_pages: @groups.total_pages,
            current_page: @groups.current_page,
            total_count: @groups.total_count
          }
        }
      end

      def show
        render json: @group.as_json(include: [:user, :members])
      end

      def create
        @group = current_user.owned_groups.build(group_params)

        if @group.save
          @group.add_member(current_user)
          render json: @group, status: :created
        else
          render_error(@group.errors.full_messages)
        end
      end

      def update
        if @group.user_id == current_user.id
          if @group.update(group_params)
            render json: @group
          else
            render_error(@group.errors.full_messages)
          end
        else
          render_unauthorized
        end
      end

      def destroy
        if @group.user_id == current_user.id
          @group.destroy
          head :no_content
        else
          render_unauthorized
        end
      end

      def join
        @group.add_member(current_user)
        render json: @group
      end

      def leave
        @group.remove_member(current_user)
        render json: @group
      end

      private

      def set_group
        @group = Group.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      def group_params
        params.require(:group).permit(:name, :description)
      end
    end
  end
end 