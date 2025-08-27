class LeaveRequestMailer < ApplicationMailer
	default from: 'chitratasker294@gmail.com'

  def leave_request_notification(user, leave_request)
    @user = user
    @leave_request = leave_request
    mail(to: user.email, subject: 'Leave Request Submitted')
  end

  def leave_request_accepted(user, leave_request)
    @user = user
    @leave_request = leave_request
    mail(to: user.email, subject: 'Leave Request Accepted')
  end

  def leave_request_rejected(user, leave_request)
    @user = user
    @leave_request = leave_request
    mail(to: @user.email, subject: 'Leave Request Rejected')
  end

  def leave_request_admin_notification(admin, leave_request)
    @admin = admin
    @leave_request = leave_request
    mail(to: admin.email, subject: 'New Leave Request')
  end
end
