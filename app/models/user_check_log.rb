class UserCheckLog < ApplicationRecord
	belongs_to :user

	def self.create_check_log(checkin, checkout, user)
		start_of_day = Date.today.beginning_of_day
        end_of_day = Date.today.end_of_day

        check_log = UserCheckLog.find_by(user_id:user.id, created_at:start_of_day..end_of_day,check_out:nil)
		if check_log 
			
			check_log.check_out = checkout
			check_log.user_id = user.id
			check_log.save!
		else
			check_log = UserCheckLog.new
			check_log.check_in = checkin
			check_log.check_out = checkout
			check_log.user_id = user.id
			check_log.save!
		end

	end

	def self.check_day_logs(user)
		start_of_day = Date.today.beginning_of_day
    end_of_day = Date.today.end_of_day
    check_logs = UserCheckLog.where(user_id:user.id, created_at:start_of_day..end_of_day)

    total_check_duration = check_logs.sum do |log|
    	if log.check_in && log.check_out
    		d1 = log.check_out
    		d2 = log.check_in
    		ts1 = d1.strftime("%H:%M:%S")
    		ts2 = d2.strftime("%H:%M:%S")
	      (ts1.to_time - ts2.to_time)
	    else
	      0
	    end
	  end

	  # total_check_duration_hours = total_check_duration / 3600.0
	  # total_check_duration_minutes = (total_check_duration % 3600) / 60.0
	  
	  # {
	  #   check_logs: check_logs.count,
	  #   total_check_duration_hours: total_check_duration_hours,
	  #   total_check_duration_minutes: total_check_duration_minutes
	  # }
	  # total_check_duration	

	  hours = total_check_duration / 3600
	  minutes = (total_check_duration % 3600) / 60
	  seconds = total_check_duration % 60

	  formatted_break_duration = format("%02d:%02d:%02d", hours, minutes, seconds)
	  ubl = UserBreakLog.break_day_logs(user)
	  check_log = UserLog.time_difference_in_hh_mm_ss(formatted_break_duration, ubl)


	end


	def self.attendance_day_logs(user, date)
		start_of_day = date.beginning_of_day
    end_of_day = date.end_of_day
		
    check_logs = UserCheckLog.where(user_id:user.id, created_at:start_of_day..end_of_day)

    total_check_duration = check_logs.sum do |log|
    	if log.check_in && log.check_out
    		d1 = log.check_out
    		d2 = log.check_in
    		ts1 = d1.strftime("%H:%M:%S")
    		ts2 = d2.strftime("%H:%M:%S")
	      (ts1.to_time - ts2.to_time)
	    else
	      0
	    end
	  end
	  hours = total_check_duration / 3600
	  minutes = (total_check_duration % 3600) / 60
	  seconds = total_check_duration % 60

	  formatted_break_duration = format("%02d:%02d:%02d", hours, minutes, seconds)
	  ubl = UserBreakLog.break_day_logs(user)
	  check_log = UserLog.time_difference_in_hh_mm_ss(formatted_break_duration, ubl)

	end

end
