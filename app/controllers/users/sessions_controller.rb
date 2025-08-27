# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  # after_action :log_login_activity, only: :create
  after_action :log_logout_activity, only: :user_sign_out
  
  def create
    super do |resource|
      if resource.persisted?
        session_ip_address = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
        resource.log_login(session_ip_address)
        if resource.approved?
          # flash[:notice] = "Signed in successfully."
          return redirect_to root_path  # Redirect to home page after sign-in
        else
          return redirect_to new_user_session_path, alert: 'Your account is not yet approved. Please contact an administrator.'
        end
      end
    end
  end

  def user_sign_out
    super do |resource|
      UserLog.update_logout_time(current_user)
    end
  end

  def update_user_log
    today = Date.today
    session_log = UserLog.find_or_initialize_by(user_id: current_user.id, date: today)

    if session_log.update(user_log_params)
      flash[:success] = "Session updated successfully."
    else
      # Handle failure (e.g., render error message)
      flash[:error] = "Failed to update session."
    end

    # Optionally redirect or render a response
    redirect_to root_path
  end

  

  private

  # def log_login_activity
  #   if user_signed_in?
  #     UserLog.create_log(current_user, Time.current, request.remote_ip)
  #   end
  # end

  def log_logout_activity
    if user_signed_in?
      current_user.user_logs.last.update(logout_time: Time.current)
    end
  end

  def user_log_params
    params.require(:user_log).permit(:check_in, :check_out, :active_time, :break_time, :inactive_time)
  end
  
end
