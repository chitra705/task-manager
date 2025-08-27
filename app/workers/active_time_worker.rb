# app/workers/active_time_worker.rb
class ActiveTimeWorker
  include Sidekiq::Worker

  def perform(user_id)
    user_log = UserLog.find_by(id: user_id)
    return unless user_log
    return if user_log.check_out.present?
    user_log.increment_active_time(120)
  end

end
