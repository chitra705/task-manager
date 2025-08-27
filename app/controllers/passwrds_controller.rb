class PasswrdsController < ApplicationController
	skip_before_action :authenticate_user!, only: [:new, :create, :new_password, :update_password]

	def new
    # Render the form to enter the email for OTP
  end


  def create
    user = User.find_by(email: params[:passwrd][:email])
    user.generate_otp
    if user
      session[:reset_email] = user.email
      UserMailer.send_reset_password_otp(user).deliver_now
      flash[:notice] = 'otp sent your email'
      redirect_to reset_password_otp_path
    else
      flash[:alert] = 'Email not found.'
      render :new
    end
  end


  def new_password
  end

  def update_password
    user = User.find_by(email: params[:email])

    if user.update(password_params)
      flash[:notice] = 'Password has been updated successfully.'
      redirect_to root_path
    else
      flash[:alert] = 'There was an error updating the password. Please try again.'
      render :new_password
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end

  
end
