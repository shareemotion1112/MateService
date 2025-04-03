class SkillsController < ApplicationController
  def create
    @skill = Skill.find_or_create_by!(name: skill_params[:name])
    render json: @skill
  end

  private

  def skill_params
    params.require(:skill).permit(:name)
  end
end
