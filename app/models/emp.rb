class Emp < ApplicationRecord
	belongs_to :user, polymorphic: true
  has_one :emp_detail
  has_many :payment_details

  enum team_type:{
    development_team: 0,
    marketing_team: 1,
    printing: 2,
    designing: 3,
    sales: 4,
    project_maintenance: 5
  }

	def self.add_emp(incoming_values)
		emp = Emp.find_by(user:incoming_values) || Emp.new 
		emp.name = incoming_values['name']
    emp.dob = incoming_values['dob']
    emp.mobile = incoming_values['mobile']
    emp.email = incoming_values['email']
    emp.address = incoming_values['address']
    emp.location = incoming_values['location']
    emp.blood_group = incoming_values['blood_group']
    emp.status = incoming_values['status']
    emp.team_type = incoming_values['team_type']
    emp.user = incoming_values
    emp.save!

    user = User.find_by(id:emp.user_id)
    user.emp_id = emp.id
    user.save!

    if emp
      ed = EmpDetail.new
      ed.emp_id = emp.id
      ed.save!

    end


	end

end
