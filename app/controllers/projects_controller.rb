class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :join, :leave]

  def index
    @projects = Project.includes(:user, :skills)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(12)
  end

  def show
    @team_members = @project.team_members.includes(:user)
  end

  def new
    @project = Project.new
  end

  def edit
    unless @project.user == current_user
      redirect_to @project, alert: 'You are not authorized to edit this project.'
    end
  end

  def create
    @project = current_user.owned_projects.build(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.user == current_user
      if @project.update(project_params)
        redirect_to @project, notice: 'Project was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @project, alert: 'You are not authorized to update this project.'
    end
  end

  def destroy
    if @project.user == current_user
      @project.destroy
      redirect_to projects_url, notice: 'Project was successfully deleted.'
    else
      redirect_to @project, alert: 'You are not authorized to delete this project.'
    end
  end

  def join
    team_member = @project.team_members.build(user: current_user, role: 'developer', status: 'pending')
    
    if team_member.save
      redirect_to @project, notice: 'Your request to join has been sent.'
    else
      redirect_to @project, alert: 'Unable to send join request.'
    end
  end

  def leave
    team_member = @project.team_members.find_by(user: current_user)
    
    if team_member&.destroy
      redirect_to @project, notice: 'You have left the project.'
    else
      redirect_to @project, alert: 'Unable to leave the project.'
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :status, skill_ids: [])
  end
end 