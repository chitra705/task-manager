class TaskMailer < ApplicationMailer
	default from: 'rchitra737@gmail.com'

	def task_assigned(task, user)
    @task = task
    @user = user
    mail(to: @user.email, subject: 'You Have Been Assigned a New Task')
  end
end
