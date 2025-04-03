class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
