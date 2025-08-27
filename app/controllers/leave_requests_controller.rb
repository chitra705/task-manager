class LeaveRequestsController < ApplicationController
	before_action :authenticate_user!
  before_action :admin_only, only: [:index]

  
  def index
    @leave_requests = LeaveRequest.where(status: "pending")
    @accepted_leaves = LeaveRequest.where(status: ["accepted", "rejected"])
  end


  def accept
    @leave_request = LeaveRequest.find(params[:id])
    if @leave_request.update(status: "accepted")
      LeaveRequestMailer.leave_request_accepted(@leave_request.user, @leave_request).deliver_now
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = 'Failed to accept leave request'
      redirect_back(fallback_location: root_path)
    end
  end

  def reject
    @leave_request = LeaveRequest.find(params[:id])
    @leave_request.update(status: "rejected")
    @leave_request.save!
    LeaveRequestMailer.leave_request_rejected(@leave_request.user, @leave_request).deliver_now
    redirect_back(fallback_location: root_path)
  end

  # def user_leave_req_list
  #   @lr_list = LeaveRequest.where(user_id:current_user.id).order(created_at: :desc)
  # end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

end

