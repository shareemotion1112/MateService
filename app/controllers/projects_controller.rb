class ProjectsController < ApplicationController
  require 'supabase_client'
  
  before_action :authenticate_user!
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :join, :leave ]

  def index
    @projects = Project.includes(:user)
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
      redirect_to @project, alert: "이 메이트 모집글을 수정할 권한이 없습니다."
    end
  end

  def create
    @project = current_user.owned_projects.build(project_params)
    
    if params[:project][:image].present?
      supa = SupabaseClient.instance
      file = params[:project][:image]
      filename = "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"
      
      begin
        result = supa.storage.from('projects').upload(
          filename,
          file.tempfile
        )
        @project.image_path = filename if result.present?
      rescue => e
        Rails.logger.error "Failed to upload image: #{e.message}"
      end
    end

    if @project.save
      redirect_to @project, notice: "메이트 모집글이 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.user == current_user
      project_attrs = project_params
      
      if params[:project][:image].present?
        supa = SupabaseClient.instance
        
        # Delete old image if exists
        if @project.image_path.present?
          begin
            supa.storage.from('projects').remove([@project.image_path])
          rescue => e
            Rails.logger.error "Failed to delete old image: #{e.message}"
          end
        end
        
        # Upload new image
        file = params[:project][:image]
        filename = "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"
        
        begin
          result = supa.storage.from('projects').upload(
            filename,
            file.tempfile
          )
          project_attrs[:image_path] = filename if result.present?
        rescue => e
          Rails.logger.error "Failed to upload image: #{e.message}"
        end
      end

      if @project.update(project_attrs)
        redirect_to @project, notice: "메이트 모집글이 수정되었습니다."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @project, alert: "이 메이트 모집글을 수정할 권한이 없습니다."
    end
  end

  def destroy
    if @project.user == current_user
      # Delete image from Supabase if exists
      if @project.image_path.present?
        begin
          supa = SupabaseClient.instance
          supa.storage.from('projects').remove([@project.image_path])
        rescue => e
          Rails.logger.error "Failed to delete image: #{e.message}"
        end
      end
      
      @project.destroy
      redirect_to projects_url, notice: "메이트 모집글이 삭제되었습니다."
    else
      redirect_to @project, alert: "이 메이트 모집글을 삭제할 권한이 없습니다."
    end
  end

  def join
    if @project.can_apply?(current_user)
      team_member = @project.team_members.build(user: current_user, role: "member", status: "pending")

      if team_member.save
        redirect_to @project, notice: "지원이 완료되었습니다."
      else
        redirect_to @project, alert: "지원에 실패했습니다."
      end
    else
      redirect_to @project, alert: "지원할 수 없는 상태입니다."
    end
  end

  def leave
    team_member = @project.team_members.find_by(user: current_user)

    if team_member&.destroy
      redirect_to @project, notice: "모집글에서 탈퇴했습니다."
    else
      redirect_to @project, alert: "탈퇴에 실패했습니다."
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :status, :required_skills)
  end
end
