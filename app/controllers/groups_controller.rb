class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join, :leave]

  def index
    @groups = Group.includes(:user, :members)
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(12)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
    unless @group.user == current_user
      redirect_to @group, alert: 'You are not authorized to edit this group.'
    end
  end

  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      @group.add_member(current_user)
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @group.user == current_user
      if @group.update(group_params)
        redirect_to @group, notice: 'Group was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @group, alert: 'You are not authorized to update this group.'
    end
  end

  def destroy
    if @group.user == current_user
      @group.destroy
      redirect_to groups_url, notice: 'Group was successfully deleted.'
    else
      redirect_to @group, alert: 'You are not authorized to delete this group.'
    end
  end

  def join
    @group.add_member(current_user)
    redirect_to @group, notice: 'You have joined the group.'
  end

  def leave
    @group.remove_member(current_user)
    redirect_to @group, notice: 'You have left the group.'
  end

  private

  def set_group
    @group = Group.includes(members: [:roles]).find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end