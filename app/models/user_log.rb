class UserLog < ApplicationRecord
	belongs_to :user, polymorphic: true

  validates :login_time, :session_ip_address, presence: true
  # validates :active_time, :break_time, presence: true, allow_nil: true
  validates :check_in, presence: true, allow_nil: true
  validates :check_out, presence: true, allow_nil: true

  after_initialize do
    self.active_time ||= 0
  end

  def self.create_log(user, login_time, ip_address)
    create(
      user: user,
      login_time: login_time,
      session_ip_address: ip_address,
      created_at: Time.current,
      updated_at: Time.current
    )
  end

  def self.format_time(seconds)
    hours = (seconds / 3600).floor
    minutes = ((seconds % 3600) / 60).floor
    seconds = (seconds % 60).floor
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def self.to_seconds(time_str)
    hours, minutes, seconds = time_str.split(':').map(&:to_i)
    (hours * 3600) + (minutes * 60) + seconds
  end

  def self.to_hh_mm_ss(total_seconds)
    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def self.time_difference_in_hh_mm_ss(ucl, ubl)
    ucl_seconds = UserLog.to_seconds(ucl)
    ubl_seconds = UserLog.to_seconds(ubl)

    difference_seconds = ucl_seconds - ubl_seconds

    to_hh_mm_ss(difference_seconds)
  end

 
  def increment_active_time(seconds = 10)
    self.active_time += seconds
    if logout_time.nil?
      self.last_active_time = Time.now
    end
    save!
  end

  def update_user_log(login_time,logout_time)
    self.login_time = login_time
    self.logout_time = logout_time
    self.save!
  end

  def formatted_active_time
    hours = active_time / 3600
    minutes = (active_time % 3600) / 60
    seconds = active_time % 60
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end


 

  
end
