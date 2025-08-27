require 'roo'
class ProjectTask < ApplicationRecord
  before_save :calculate_duration
  has_many :task_logs
  
  belongs_to :created_by, polymorphic: true
  belongs_to :assigned_to, polymorphic: true, optional: true
  # serialize :description
  # belongs_to :team, polymorphic: true

	enum status:{
  	active: 0,
  	paused: 1,
  	completed: 2
  }
  # before_save :calculate_duration, if: -> { status_changed? && status == 'completed' }

  validates :title, presence: true
  validates :status, presence: true
  # validates :status, inclusion: { in: %w[Active Paused Completed] }

  def self.create_task(incoming_values)
    t = ProjectTask.new(incoming_values)
    t.title       = incoming_values['title']
    t.description = incoming_values['description']
    t.status      = incoming_values['status']
    t.duration    = incoming_values['duration']
    
    t.save!
  end

  def self.find_team(emp_id)
    team = DevTeam.find_by_emp_id(emp_id) || MarkettingTeam.find_by_emp_id(emp_id)
    team
  end

  # def self.update_task(user_id,incoming_values)
  #   t = ProjectTask.find_by(id:id)
  #   t.title       = incoming_values['title']
  #   t.description = incoming_values['description']
  #   t.status      = incoming_values['status']
  #   t.duration    = incoming_values['duration']
  #   t.save!   
  # end

  def delete_task(user_id)
    t = ProjectTask.find_by(id:user_id)
    t.delete()
  end

  def get_all
    ProjectTask.all
  end

  def self.average_completion_time_per_week
    completed_tasks = ProjectTask.where(status: 'completed')
    completed_tasks.group(:created_at)
  end

  def self.status_counts
    ProjectTask.group(:status).count
  end

  def self.assign_task(pt_id, user_id)
    user = User.find_by(id:user_id)
    pt = ProjectTask.find_by(id:pt_id)
    pt.assigned_to_type = user.class.name
    pt.assigned_to_id = user.id 
    pt.save!
    TaskMailer.task_assigned(pt,user).deliver_now 
  end

  def self.average_completion_time_per_week
    completed_tasks = ProjectTask.where(status: 'completed')
    completed_tasks.group(:created_at)
  end

  def self.filter_by_status(status)
    where(status: statuses[status])
  end

  def self.filter_by_date(range)
    case range
    when 'today'
      where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    when 'this_week'
      where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
    when 'this_month'
      where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
    when 'last_month'
      where(created_at: (Time.zone.now - 1.month).beginning_of_month..(Time.zone.now - 1.month).end_of_month)
    else
      all
    end
  end

  def self.filter_by_completion_time(min_time, max_time)
    where(duration: min_time..max_time)
  end

  def self.upload_task_file(file, current_user)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      task = ProjectTask.new(
        title: row['title'],
        description: row['description'],
        team_id: row['team_id'],
        status: row['status'],
        assigned_to_id: row['assigned_to_id'],
        assigned_to_type: row['assigned_to_type'],
        duration: row['duration'],
        created_by_id: current_user.id,
        created_by_type: current_user.class.name
      )
      
      unless task.save
        Rails.logger.error "Task could not be saved: #{task.errors.full_messages.join(', ')}"
      end
    end
  end

  private

  def calculate_duration
    if due_start_date && due_end_date
      self.duration = ((due_end_date - due_start_date) * 24).to_i
    else
      self.duration = 0
    end
  end

end
