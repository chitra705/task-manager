class EmployeesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:save_session_data]

  def save_session_data
    employee = Employee.find_by(user_id: current_user.id) || Employee.new(user_id:current_user.id,user_type:current_user.class.name)

    if employee
      if params[:check_out].present? # If there's a check-out time provided, update the session data
        employee.update(
          check_out: params[:check_out],
          logout: Time.current
        )
        render json: { message: 'Session data updated successfully' }, status: :ok
      else
        # If no check-out time provided, create a new session entry
        employee.sessions.create(
          check_in: params[:check_in],
          login: Time.current,
          session_ip_address: params[:session_ip_address]
        )
        render json: { message: 'Session data saved successfully' }, status: :ok
      end
    else
      render json: { error: 'Employee not found' }, status: :not_found
    end
  end

  private

  def update_active_inactive_times(employee)
    if params[:check_out].present?
      update_inactive_time(employee)
    else
      update_active_time(employee)
    end
  end
end
