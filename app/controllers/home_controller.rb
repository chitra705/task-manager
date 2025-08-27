class HomeController < ApplicationController

  before_action :authenticate_user!

  def index
    @project_tasks = ProjectTask.where(assigned_to: current_user)
    # if params[:filter_status].present?
    #   @project_tasks = @project_tasks.where(status: params[:filter_status])
    # end
    @check_logs = UserLog.where(user: current_user, created_at: Time.now.beginning_of_month..Time.now)
    user_cl = UserLog.where(user: current_user, created_at: Time.now.beginning_of_month..Time.now.end_of_month).group("DATE(created_at)").count
    @cl = User.calender_data(current_user)
    @total_leave_days = calculate_total_leave_days - user_cl.keys.count
    @total_hour_per_day = UserCheckLog.check_day_logs(current_user)
  end

  def update_user_log
    check_log = UserCheckLog.create_check_log(params[:check_in], params[:check_out], current_user)

    redirect_back(fallback_location: root_path)
  end

  def update_user_break
    break_log = UserBreakLog.create_break_log(params[:break_start],params[:break_end], current_user)

    redirect_back(fallback_location: root_path)
  end

  def admin_leave_requests
    @leave_requests = LeaveRequest.where(approved: false)
  end

  def create_leave_request
    @leave_request = current_user.leave_requests.new(leave_request_params)

    if @leave_request.save
      admin = User.find_by(role: 'admin')
      LeaveRequestMailer.leave_request_admin_notification(admin, @leave_request).deliver_now

      redirect_to root_path, notice: 'Leave request submitted successfully'
      
    else
      render json: { message: 'Error submitting leave request.' }, status: :unprocessable_entity
    end
  end

  private

  def leave_request_params
    params.require(:leave_request).permit(:leave_date, :leave_reason)
  end

  def user_log_params
    params.require(:user_log).permit(:check_in, :check_out, :active_time, :break_time, :inactive_time)
  end

  def add_times(existing_time, new_time)
    existing_seconds = time_to_seconds(existing_time)
    new_seconds = time_to_seconds(new_time)
    total_seconds = existing_seconds + new_seconds
    seconds_to_time(total_seconds)
  end

  # def time_to_seconds(time)
  #   return 0 if time.blank?
  #   parts = time.split(':').map(&:to_i)
  #   parts[0] * 3600 + parts[1] * 60 + parts[2]
  # end

  def time_to_seconds(time_str)
    return 0 if time_str.nil?

    parts = time_str.split(':').map(&:to_i)
    parts[0] * 3600 + parts[1] * 60 + parts[2]
  rescue StandardError
    0
  end

  def seconds_to_time(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    seconds = seconds % 60
    format('%02d:%02d:%02d', hours, minutes, seconds)
  end

  def calculate_total_leave_days
    start_date = Date.today.beginning_of_month
    end_date = Date.today
    (start_date..end_date).count { |date| date.wday != 0 }
  end

end

