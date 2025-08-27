# app/workers/scheduler_worker.rb
class SchedulerWorker
  include Sidekiq::Worker

  def perform
    UserLog.where('check_out IS NULL').find_each do |user_log|
      ActiveTimeWorker.perform_async(user_log.id)
    end
  end
end
