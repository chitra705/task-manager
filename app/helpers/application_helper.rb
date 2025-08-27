module ApplicationHelper
	def format_timer(task_log)
	  if task_log.status == 'active'
	    elapsed_time = task_log.active
	    hours, minutes = (elapsed_time / 3600).to_i, ((elapsed_time % 3600) / 60).to_i
	    format('%02d:%02d', hours, minutes)
	  else
	    '00:00'
	  end
  end
end
