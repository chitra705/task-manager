class UserMailer < ApplicationMailer
	default from: 'rchitra737@gmail.com'

  def send_otp(user)
    @user = user
    mail(to: @user.email, subject: 'Your OTP Code')
  end

  def send_reset_password_otp(user)
    @user = user
    mail(to: @user.email, subject: 'Your OTP Code')
  end

  def admin_approval_request(user)
    @user = user
    mail(to: User.all.pluck(:email), subject: 'New User Approval Request')
  end

  def user_approved(user)
    @user = user
    mail(to: @user.email, subject: 'Your Account is Approved')
  end

  def user_rejected(user)
    @user = user
    mail(to: @user.email, subject: 'Your Account is Rejected')
  end
  
end
