
namespace :payment_details do
  desc "Create PaymentDetails for all employees for the first day of the current month"
  task create_payment: :environment do
    first_day_of_month = Date.today.beginning_of_month
    employees = Emp.all

    employees.each do |employee|
      emp_detail = employee.emp_detail

      if emp_detail
        pay_detail = PaymentDetail.create(
          total_salary: emp_detail.basic_salary,
          given_amount: 0,
          details_img: nil,
          emp_id: employee.id,
          user_id: employee.user_id
        )
        puts "PaymentDetail created for Employee #{employee.id} for #{first_day_of_month.month}/#{first_day_of_month.year}"
      else
        puts "No emp_detail or user found for Employee #{employee.id}"
      end
    end
  end
end
