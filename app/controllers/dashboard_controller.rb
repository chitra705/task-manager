class DashboardController < ApplicationController
  before_action :authenticate_user!
  helper_method :time_remaining

  def index
    @user_tasks = ProjectTask.where(assigned_to_id: current_user.id, assigned_to_type: 'User')

    if current_user.admin? || current_user.manager? || current_user.team_lead?
      @tasks = ProjectTask.all

      if params[:status].present?
        @tasks = @tasks.filter_by_status(params[:status])
      end

      if params[:date_range].present?
        @tasks = @tasks.filter_by_date(params[:date_range])
      end

      if params[:min_time].present? && params[:max_time].present?
        @tasks = @tasks.filter_by_completion_time(params[:min_time].to_f, params[:max_time].to_f)
      end

      @status_counts = @tasks.status_counts
      # @tasks_created_per_day = @tasks.group_by_day(:created_at).count.transform_keys(&:to_s)
      # @average_completion_time_per_week = @tasks.group_by_week(:created_at).average(:duration)
    
@tasks_created_per_day = @tasks.map { |task| task.created_at.in_time_zone('Asia/Kolkata').to_date }
                                .tally # Counts occurrences per date
                                .transform_keys { |date| date.strftime('%Y-%m-%d') }


@average_completion_time_per_week = @tasks.group_by { |task| task.created_at.in_time_zone('Asia/Kolkata').strftime('%Y-%W') }
                                           .transform_values { |tasks| tasks.sum(&:duration) / tasks.size.to_f }
      
      # Count assigned and not assigned tasks
      @assigned_count = @tasks.where.not(assigned_to_id: nil).count
      @not_assigned_count = @tasks.where(assigned_to_id: nil).count
      @task_logs = TaskLog.where(project_task_id: @tasks.pluck(:id))
      @user_active_tasks = @user_tasks.where(status: 'active')
      @task_time_distributions = @user_active_tasks.each_with_object({}) do |task, hash|
        hash[task.title] = time_distribution(task)
      end
    else

      @user_status_counts = @user_tasks.group(:status).count
      @user_active_tasks = @user_tasks.where(status: 'active')
      @active_task_counts = @user_active_tasks.group(:status).count

      @task_time_distributions = @user_active_tasks.each_with_object({}) do |task, hash|
        hash[task.title] = time_distribution(task)
      end
    end
    # @break_log = UserBreakLog.break_day_logs(current_user)
    # ucl = UserCheckLog.check_day_logs(current_user)
    # @check_log = UserLog.time_difference_in_hh_mm_ss(ucl, @break_log)

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


  

  # def download_user_logs
  #   @user_logs = UserLog.all    

  #   respond_to do |format|
  #     format.csv do
  #       headers['Content-Disposition'] = "attachment; filename=\"user_logs.csv\""
  #       headers['Content-Type'] ||= 'text/csv'
        
  #       csv_data = CSV.generate(headers: true) do |csv|
  #         csv << ['User', 'Login Time', 'Check-in Time', 'Check-out Time', 'Logout Time']

  #         @user_logs.each do |log|
  #           csv << [log.user.name, log.login_time&.strftime('%H:%M'),log.check_in&.strftime('%H:%M'), log.check_out&.strftime('%H:%M'),log.logout_time&.strftime('%H:%M')]
  #         end
  #       end

  #       render plain: csv_data
  #     end
  #   end
  # end


  def download_user_logs
    @user_logs = UserLog.all    

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"user_logs.csv\""
        headers['Content-Type'] ||= 'text/csv'

        csv_data = CSV.generate(headers: true) do |csv|
          # CSV Headers
          csv << ['User', 'Login Time', 'Check-in Time', 'Check-out Time', 'Logout Time']

          @user_logs.each do |log|
            csv << [
              log.user.name,
              log.login_time&.strftime('%H:%M'),
              log.check_in&.strftime('%H:%M'),
              log.check_out&.strftime('%H:%M'),
              log.logout_time&.strftime('%H:%M')
            ]
          end
        end

        render plain: csv_data
      end
      format.html do
        render template: 'user_logs/download_user_logs'
      end
    end
  end


  private

  def time_remaining(due_start_date, due_end_date)
    return "Due date not set" if due_end_date.nil?

    remaining_time = due_end_date - Time.current
    if remaining_time.positive?
      distance_of_time_in_words(Time.current, due_end_date)
    else
      "Due date has passed"
    end
  end

  def time_distribution(task)
    return {} unless task.due_start_date.present? && task.due_end_date.present?

    total_duration = (task.due_end_date - task.due_start_date).to_i
    time_remaining = [(task.due_end_date - Date.today).to_i, 0].max
    time_elapsed = total_duration - time_remaining

    {
      "Time Elapsed" => 2,
      "Time Remaining" => 5
    }
  end

  def generate_csv(user_logs)
    CSV.generate(headers: true) do |csv|
      csv << ['User', 'Login Time', 'Check-in Time', 'Check-out Time', 'Logout Time'] # Add more headers as needed

      user_logs.each do |log|
        csv << [
          log.user.name,
          log.login_time&.strftime('%H:%M'),
          log.check_in&.strftime('%H:%M'),
          log.check_out&.strftime('%H:%M'),
          log.logout_time&.strftime('%H:%M')
        ]
      end
    end
  end

end
