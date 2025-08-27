class TaskLog < ApplicationRecord
	belongs_to :project_task, polymorphic: true, optional: true
	enum status:{
  	active: 0,
  	paused: 1
  }

  def self.create_task_log(pt, status, user,active_timer_count = nil)
  	start_of_day = Date.today.beginning_of_day
    end_of_day = Date.today.end_of_day
	  task_log = TaskLog.find_by(project_task_id: pt.id, user_id: user.id, created_at: start_of_day..end_of_day) || TaskLog.new(project_task_id: pt.id, user_id: user.id)
	  task_log.status = status
	  task_log.project_task_type = pt.class.name

	  case status
	  when 'active'
	    task_log.status = 'active'
	    task_log.start_time = DateTime.now
	    task_log.active = TaskLog.convert_seconds_to_time(active_timer_count)
	  when 'paused'
	    task_log.status = 'paused'
	  end

	  task_log.save!
	  task_log
	end


  def total_elapsed_time
    if status == 'active' && start_time.present?
      (elapsed_time || 0) + (Time.current - start_time).to_i
    else
      elapsed_time || 0
    end
  end

  def formatted_time(seconds)
    minutes = (seconds / 60).to_i
    seconds = (seconds % 60).to_i
    "#{minutes}m #{seconds}s"
  end

  def self.convert_seconds_to_time(seconds_str)
	  total_seconds = seconds_str.to_i
	  minutes = total_seconds / 60
	  seconds = total_seconds % 60
	  formatted_time = "#{minutes.to_s.rjust(2, '0')}m #{seconds.to_s.rjust(2, '0')}s"
	  
	  formatted_time
	end

end
