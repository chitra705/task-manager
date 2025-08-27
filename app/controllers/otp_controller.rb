class OtpController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :reset_password, :reset_verify]

	def new
  end

  def create
    user = User.find(session[:otp_user_id])

    if user.otp_valid?(params[:otp])
      user.confirm
      sign_in(user)
      session.delete(:otp_user_id)  # Clear the session after successful sign-in
      redirect_to root_path, notice: 'Your account has been successfully verified.'
    else
      flash[:alert] = 'Invalid OTP. Please try again.'
      render :new
    end
  end

  def reset_verify
    user = User.find_by(email: params[:email])

    if user && user.otp_valid?(params[:otp])
      session[:reset_email] = user.email
      user.confirm
      session.delete(:otp_user_id)
      redirect_to new_otp_password_path, notice: 'Your account has been successfully verified.'
    else
      flash[:alert] = 'Invalid OTP. Please try again.'
      render :reset_password
    end
  end

  def reset_password
  end

  

end
