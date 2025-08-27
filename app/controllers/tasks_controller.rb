class TasksController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: :upload_file
  after_action :verify_authorized, except: :download_csv
  include Pundit::Authorization
  before_action :set_project_task, only: [:show, :edit, :update, :destroy, :task_delete, :update_status, :update_task_log_status]
  require 'roo'
  require 'csv'
  skip_after_action :verify_authorized, only: [:update_task_log_status, :create]

  def index
    @project_tasks = ProjectTask.all
    authorize @project_tasks
    if params[:filter_status].present?
      @project_tasks = @project_tasks.where(status: params[:filter_status])
    end
    start_of_day = Date.today.beginning_of_day
    end_of_day = Date.today.end_of_day
    @task_log = TaskLog.where(project_task_id:@project_tasks.ids, user_id: current_user.id, created_at: start_of_day..end_of_day)
    @my_task  = @project_tasks.where(assigned_to_id: current_user.id)
  end


  def show
    authorize @project_task
    start_of_day = Date.today.beginning_of_day
    end_of_day = Date.today.end_of_day
  end

  def new
    @project_task = ProjectTask.new
    authorize @project_task
  end

  def get_team_members
    team_type = params[:team_type]
    members = User.where(team_type: User.team_types[team_type])
    render json: members.map { |user| { id: user.id, name: user.name } }
  end


  # def create
  #   @project_task = ProjectTask.new(project_task_params)
  #   @project_task.created_by = current_user
  #   team = ProjectTask.find_team(current_user.emp_id)
  #   # team_name = params[:team]

  #   # @project_task.team_type =  
  #   # @project_task.team_id = 

  #   authorize @project_task
  #   if @project_task.save
  #   else
  #     render :new
  #   end
  # end

  def create
    @project_task = ProjectTask.new(project_task_params)
    @project_task.created_by = current_user
     @project_task.assigned_to_type = "User"
     calculate_duration(@project_task)
    team = ProjectTask.find_team(current_user.emp_id)
    @users = User.where(team_type: params[:project_task][:team_type])

    authorize @project_task
    if @project_task.save
      task_log_status = "paused"
      task_log = TaskLog.create_task_log(@project_task,task_log_status,current_user)
      redirect_to task_path(@project_task), notice: 'Project task was successfully created.'
    else
      render :new
    end
  end


  def update_task_log_status
    @project_task = ProjectTask.find_by(id:params[:task_id])
    @task_log = TaskLog.create_task_log(@project_task,params[:status],current_user,params[:active])
    
    redirect_back(fallback_location: tasks_path)
  end


  def edit
    authorize @project_task
  end

  def update
    authorize @project_task
    if @project_task.update(project_task_params)
      redirect_to task_path(@project_task), notice: 'Project task was successfully updated.'
    else
      render :edit
    end
  end

  def update_status
    @project_task = ProjectTask.find(params[:id])
    authorize @project_task

    if @project_task.update(task_params)
      redirect_to tasks_path, notice: 'Task status was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @project_task
    @project_task.destroy
    redirect_to project_tasks_url, notice: 'Project task was successfully destroyed.'
  end

  def task_delete
    authorize @project_task
    if @project_task.delete
      flash[:alert] = 'Task was successfully destroyed.'
      redirect_to 
    else
      redirect_to tasks_path, alert: 'Failed to destroy the project task.'
    end
  end

  def assign
    user_id = params[:project_task][:user_id]
    pt_id = params[:id]
    @project_task = ProjectTask.find(pt_id)
    authorize @project_task
    assigned_user = User.find(user_id)
    render json:ProjectTask.assign_task(pt_id, user_id), notice: 'Task assigned'
  end


  def move
    @project_task.update(status: params[:status])
    redirect_to @project_task, notice: 'Task status was successfully updated.'
  end

  def upload_file
    file = params[:file]
    if file.present?
      ProjectTask.upload_task_file(file, current_user)
      redirect_to tasks_path, notice: "Tasks successfully uploaded."
    else
      redirect_to new_task_path, alert: "Please upload a valid Excel file."
    end
  end


  def download_csv
    @tasks = ProjectTask.all

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"download_csv.csv\""
        headers['Content-Type'] ||= 'text/csv'
        
        # Generate the CSV
        csv_data = CSV.generate(headers: true) do |csv|
          # Add the header row
          csv << ['Task Title', 'Description', 'Status', 'Assigned To']

          # Add task rows
          @tasks.each do |task|
            csv << [task.title, task.description, task.status, task.assigned_to ? task.assigned_to.name : 'Not Assigned']
          end
        end

        # Send the CSV data as the response
        render plain: csv_data
      end
    end
  end

  def download_csv
    @tasks = ProjectTask.all

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"tasks.csv\""
        headers['Content-Type'] ||= 'text/csv'

        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['Task Title', 'Description', 'Status', 'Assigned To']

          @tasks.each do |task|
            csv << [
              task.title, 
              task.description, 
              task.status.titleize, # Converts status to human-readable form
              task.assigned_to ? task.assigned_to.name : 'Not Assigned'
            ]
          end
        end

        render plain: csv_data
      end

      format.html do
        render template: 'tasks/download_user_logs'
      end
    end
  end


  private

  def set_project_task
    @project_task = ProjectTask.find_by(id: params[:id])
    if @project_task.nil?
      flash[:alert] = 'Task not found.'
      redirect_to root_path
    end
  end

  def project_task_params
    params.require(:project_task).permit(:title, :description, :status, :duration, :assigned_to_id, :due_start_date, :due_end_date)
  end

  # def user_log_params
  #   params.require(:user_log).permit(:check_in, :check_out, :active_time, :break_time)
  # end

  def task_params
    params.require(:project_task).permit(:status)
  end

  def calculate_duration(project_task)
    if project_task.due_start_date && project_task.due_end_date
      start_date_time = project_task.due_start_date.to_datetime
      end_date_time = project_task.due_end_date.to_datetime
      project_task.duration = ((end_date_time - start_date_time) * 24).to_i
    else
      project_task.duration = 0
    end
  end

  def task_log_params
    params.permit(:status, :active, :task_id)
  end

  
end
