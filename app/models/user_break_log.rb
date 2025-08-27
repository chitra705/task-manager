class UserBreakLog < ApplicationRecord
	belongs_to :user



	def self.create_break_log(break_start, break_end, user)
		start_of_day = Date.today.beginning_of_day
        end_of_day = Date.today.end_of_day

        break_log = UserBreakLog.find_by(user_id:user.id, created_at:start_of_day..end_of_day,break_out:nil)
		if break_log 
			
			break_log.break_out = break_end
			# break_log.user_id = user.id
			break_log.save!
		else
			break_log = UserBreakLog.new
			break_log.break_in = break_start
			break_log.break_out = break_end
			break_log.user_id = user.id
			break_log.save!
		end

	end

	def self.break_day_logs(user)
		start_of_day = Date.today.beginning_of_day
    end_of_day = Date.today.end_of_day
    break_logs = UserBreakLog.where(user_id:user.id, created_at:start_of_day..end_of_day)

    total_break_duration = break_logs.sum do |log|
    	if log.break_in && log.break_out
    		d1 = log.break_out
    		d2 = log.break_in
    		ts1 = d1.strftime("%H:%M:%S")
    		ts2 = d2.strftime("%H:%M:%S")
	      (ts1.to_time - ts2.to_time)
	    else
	      0
	    end
	  end

	  # total_break_duration_hours = total_break_duration / 3600.0
	  # total_break_duration_minutes = (total_break_duration % 3600) / 60.0

	  hours = total_break_duration / 3600
	  minutes = (total_break_duration % 3600) / 60
	  seconds = total_break_duration % 60
	  
	  # {
	  #   break_logs: break_logs.count,
	  #   total_break_duration_hours: total_break_duration_hours,
	  #   total_break_duration_minutes: total_break_duration_minutes
	  # }
	  # total_break_duration_hours
	  formatted_break_duration = format("%02d:%02d:%02d", hours, minutes, seconds)
	  

	end

end
