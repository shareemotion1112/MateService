module Api
  module V1
    class ProjectsController < BaseController
      before_action :set_project, only: [:show, :update, :destroy]

      def index
        @projects = Project.includes(:user, :skills)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(20)

        render json: {
          projects: @projects,
          meta: {
            total_pages: @projects.total_pages,
            current_page: @projects.current_page,
            total_count: @projects.total_count
          }
        }
      end

      def show
        render json: @project.as_json(include: [:user, :skills, :team_members])
      end

      def create
        @project = current_user.owned_projects.build(project_params)

        if @project.save
          render json: @project, status: :created
        else
          render_error(@project.errors.full_messages)
        end
      end

      def update
        if @project.update(project_params)
          render json: @project
        else
          render_error(@project.errors.full_messages)
        end
      end

      def destroy
        @project.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      def project_params
        params.require(:project).permit(:title, :description, :status, skill_ids: [])
      end
    end
  end
end 