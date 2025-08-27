# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]


  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
   
    resource.approved = false 
    resource.generate_otp
    admin = AdminUser.find_by(email:resource.email)

    if resource.save(validate: false)
      UserMailer.send_otp(resource).deliver_now
      UserMailer.admin_approval_request(resource).deliver_now
      session[:otp_user_id] = resource.id
      redirect_to new_user_otp_path, notice: 'Admin approval is required to activate your account.'
      emp = Emp.add_emp(resource)
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      
      flash[:alert] = resource.errors.full_messages.to_sentence
      render :new and return
    end
    
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  def user_sign_out
    ul = current_user.user_logs.last
    ul.logout_time = Time.now
    ul.save!
    sign_out(current_user)
    redirect_to new_user_session_path, notice: 'Signed out successfully.'
    # UserLog.update_logout_time(current_user) if current_user 
  end

  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :mobile, :role, :dob, :address, :location, :blood_group, :status,:team_type])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :mobile, :email, :current_password, :dob, :address, :location, :blood_group])
  end

end
