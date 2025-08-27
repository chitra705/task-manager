class UpdateActiveTimeJob < ApplicationJob
  queue_as :default

  def perform
    user_log = UserLog.find_by(user_id: current_user.id, log_date: Date.today)
    return unless user_log

    user_log.last_active_time = Time.zone.now
    user_log.save!
  end
end
