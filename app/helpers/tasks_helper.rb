module TasksHelper
  def task_log_active_time(task_log)
    if task_log && task_log.active
      time_format(task_log.active)
    else
      "Not started"
    end
  end

  def task_log_pause_time(task_log)
    if task_log && task_log.pause
      time_format(task_log.pause)
    else
      "Not paused"
    end
  end

  def time_format(seconds)
    minutes = (seconds / 60).to_i
    seconds = (seconds % 60).to_i
    "#{minutes}m #{seconds}s"
  end

  private

  def time_format(time)
    time.strftime("%H:%M:%S") if time
  end
end
