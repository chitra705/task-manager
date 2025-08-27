class UsersController < ApplicationController
  layout 'application'
	before_action :authenticate_user!
  before_action :admin_only, only: [:index, :approve, :reject]

  def index
    @users = User.where(approved: false)
    @accepted_users = User.where(approved: true)
  end

  def approve
    @user = User.find(params[:id])
    @user.role = params[:role]
    @user.update(approved: true)
    UserMailer.user_approved(@user).deliver_now
    redirect_to users_path, notice: 'User has been approved.'
  end

  def reject
    @user = User.find(params[:id])
    UserMailer.user_rejected(@user).deliver_now
    redirect_to users_path, notice: 'User has been rejected.'
    @user.destroy
  end

  
  private

  def admin_only
    unless current_user.admin? || current_user.manager?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
