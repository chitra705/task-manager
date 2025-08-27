class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :check_user_approved

  # def authenticate_user!
  #   unless user_signed_in?
  #     flash[:alert] = "Please log in to continue"
  #     redirect_to new_user_session_path
  #   end
  # end

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  if method_defined?(:authenticate_user!)
    alias_method :devise_authenticate_user!, :authenticate_user!
  end

  def handle_missing
    render plain: "404 Not Found", status: :not_found
  end


	private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
  
  def check_user_approved
    if current_user && !current_user.approved?
      sign_out current_user
      redirect_to new_user_session_path, alert: 'Your account is not approved yet.'
    end
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  # def log_user_activity
  #   if user_signed_in?
  #     UserLog.create_log(current_user, Time.current, request.remote_ip)
  #   end
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :mobile, :dob, :address, :location, :blood_group, :status])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :mobile, :email, :role, :dob, :address, :location, :blood_group, :status])
  end

  def current_user_session_ip_address
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end

  
end
