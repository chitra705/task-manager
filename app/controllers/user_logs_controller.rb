class UserLogsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_user_log]

  before_action :authenticate_user!

  
  def index
    @user_logs_mnth = UserLog.where("created_at >= ? AND created_at < ?", Time.current.beginning_of_month, Time.current.end_of_month)
                             .order(created_at: :desc)
  end

  def daily_log_user
    @break_log = UserBreakLog.break_day_logs(current_user)
    @check_log = UserCheckLog.check_day_logs(current_user)
    
    @user_day_logs = [
      ["Check Log", @check_log],
      ["Break Log", @break_log]
    ]


 

    if params[:date_range_start].present?
      start_date = Date.parse(params[:date_range_start])
      end_date = params[:date_range_end].present? ? Date.parse(params[:date_range_end]) : Date.today
      @user_logs = UserLog.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      @user_check_logs = UserCheckLog.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      @user_break_logs = UserBreakLog.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    else
      @user_logs = UserLog.where(created_at: Date.today.all_day)
      @user_check_logs = UserCheckLog.where(created_at: Date.today.all_day)
      @user_break_logs = UserBreakLog.where(created_at: Date.today.all_day)
    end
    @teams_with_logs = @user_logs.includes(:user).group_by { |log| log.user.team_type } 

    @lr_list = LeaveRequest.where(user_id:current_user.id).order(created_at: :desc).limit(10)
    @leave_data = @lr_list.map do |leave_request|
      {
        leave_date: leave_request.leave_date.strftime('%Y-%m-%d'), # Convert to string for chart axis
        status: leave_request.status,  # Status (e.g., pending, approved)
        reason: leave_request.leave_reason # Reason for leave
      }
    end
  end


  def edit_user_log
    @edit_user_time = UserLog.find(params[:id])
    if @edit_user_time.update(user_log_params)
      respond_to do |format|
        format.html { redirect_to user_logs_path, notice: 'User Log successfully updated.' }
        format.js
      end
    else
      render :edit
    end
  end

  def update
    @user_log = UserLog.find(params[:id])
    if @user_log
      @user_log.update_user_log(params[:login_time], params[:logout_time])
      redirect_to user_logs_path, notice: 'User Log successfully updated.'
    else
      render :index
    end
  end



  def update_user_log
    # UserLog.where(created_at:Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).last
    
        
      @user_log = UserLog.where(user_id: current_user.id, created_at:Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).last    
      @user_log.last_active_time = params[:last_active_time]
      @user_log.save
      
  end

  # def update_user_log
  #   @user_log = UserLog.find_or_initialize_by(user_id: current_user.id)
    
  #   current_time = params[:last_active_time].to_time # Assuming it's in a valid time format
  #   previous_time = @user_log.last_active_time.to_time if @user_log.last_active_time

  #   @user_log.last_active_time = current_time
    
  #   if previous_time
  #     time_difference = current_time - previous_time

  #     @user_log.active_time ||= 0
  #     @user_log.active_time += time_difference
  #   end
  #   @user_log.save

    
  # end








 
 
end
