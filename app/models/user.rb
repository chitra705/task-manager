class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  enum status:{
    active: 0,
    inactive: 1
  }

  enum role:{ 
    admin: 0,
    manager: 1,
    team_lead: 2,
    team_member: 3 
  }
  enum team_type:{
    development_team: 0,
    marketing_team: 1,
    printing: 2,
    designing: 3,
    sales: 4,
    project_maintenance: 5
  }
  
  has_one :emp, as: :user
  has_one :project_task, as: :user
  has_many :project_tasks, as: :created_by
  has_one :project_tasks, as: :assigned_to
  has_many :user_logs, as: :user
  has_many :leave_requests
  has_one :sal_payslip
  has_one :payslip_value
  has_many :payment_details

 
  scope :admins, -> { where(role: 'admin') }

  # validates :password, presence: true, length: { minimum: 6 }, format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])./, message: "must include at least one uppercase letter, one lowercase letter, one digit, and one special character" }
 validate :password_complexity

  def self.admins
    where(role: 'admin')
  end
  def has_role?(role)
    self.role == role.to_s
  end

  def generate_otp
    self.otp = SecureRandom.random_number(900000) + 100000 # Generates a random 6-character OTP
    self.otp_sent_at = Time.current
    save!
  end

  def send_otp_email
    generate_otp
    UserMailer.send_otp(self).deliver_now
  end

  def otp_valid?(submitted_otp)
    otp == submitted_otp && otp_sent_at > 10.minutes.ago
  end

  def update_user_emp_id(emp)
    self.emp_id = emp.id
    self.save!
  end

  def admin?
    role == 'admin'
  end

  def log_login(session_ip_address)
    begin
      user_logs.create!(login_time: Time.current, session_ip_address: session_ip_address, log_date:Date.today)
    rescue => e
      Rails.logger.error "Error saving UserLog: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  def log_logout
    Rails.logger.debug "Logging out user #{self.id} at #{Time.current}"

    last_log = user_logs.order(created_at: :desc).first
    if last_log.present? && last_log.logout_time.nil?
      last_log.update(logout_time: Time.current)
      Rails.logger.debug "Updated existing log entry with logout time."
    else
      new_log = user_logs.create(logout_time: Time.current, session_ip_address: nil)
      if new_log.valid?
        Rails.logger.debug "Created new log entry with logout time."
      else
        Rails.logger.error "Error creating new log entry: #{new_log.errors.full_messages.join(', ')}"
      end
    end
  end


  def self.calender_data(user)
    user_logs = UserLog.where(user: user, created_at: Time.now.beginning_of_month..Time.now)
    logs_by_date = user_logs.group_by { |log| log.created_at.to_date }.transform_values { |logs| logs.map(&:user_id) }
    time_date_hash = {}
    logs_by_date.keys.each do |date| 
      time = UserCheckLog.attendance_day_logs(user, date)
      time_date_hash[date] = time.split(':').first.to_i
    end
    time_date_hash

  end


  private

  def password_complexity
    return if password.blank?

    if password.length < 6
      errors.add :password, "is too short (minimum is 6 characters)"
    end
    unless password =~ /[A-Z]/
      errors.add :password, "must include at least one uppercase letter"
    end
    unless password =~ /[a-z]/
      errors.add :password, "must include at least one lowercase letter"
    end
    unless password =~ /[0-9]/
      errors.add :password, "must include at least one digit"
    end
    unless password =~ /[\W]/
      errors.add :password, "must include at least one special character"
    end
  end
  
  
end
