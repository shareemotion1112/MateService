module Api
  module V1
    class SkillsController < BaseController
      def index
        @skills = Skill.includes(:users, :projects)
                      .order(name: :asc)
                      .page(params[:page])
                      .per(50)

        render json: {
          skills: @skills,
          meta: {
            total_pages: @skills.total_pages,
            current_page: @skills.current_page,
            total_count: @skills.total_count
          }
        }
      end

      def show
        @skill = Skill.find(params[:id])
        render json: @skill.as_json(include: [ :users, :projects ])
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end
    end
  end
end
