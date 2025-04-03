class RolesController < ApplicationController
  def create
    @role = Role.find_or_create_by!(
      name: role_params[:name],
      category: role_params[:category]
    )
    render json: @role
  end

  private

  def role_params
    params.require(:role).permit(:name, :category)
  end
end
