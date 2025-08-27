class SalPayslip < ApplicationRecord
	has_many :payslip_values
	belongs_to :user

	def self.create_payslip(incoming_values, user)
	  sp = SalPayslip.find_by(id:incoming_values[:id]) || SalPayslip.new
    sp.pay_period= incoming_values[:pay_period]
    sp.worked_days= incoming_values[:worked_days]
    sp.designation= incoming_values[:designation]
    sp.department= incoming_values[:department]
    sp.user_id= user.id
    sp.save!
	  
  


	  if sp.save

	  	payslip_values=[

			{"earnings"=>"sal1", "earning_amount"=>"100", "deductions"=>"pf", "deduction_amount"=>"2"},
			{"earnings"=>"sal2", "earning_amount"=>"200", "deductions"=>"pf", "deduction_amount"=>"3"},
			{"earnings"=>"sal3", "earning_amount"=>"300", "deductions"=>"pf", "deduction_amount"=>"5"}

			]
	  	incoming_values[:payslip_values].each do |value|
	      pv = PayslipValue.new
	      pv.earnings = value["earnings"]
	      pv.earning_amount = value["earning_amount"]
	      pv.deductions = value["deductions"]
	      pv.deduction_amount = value["deduction_amount"]
	      pv.sal_payslip_type = sp.class.name
	      pv.sal_payslip_id = sp.id
	      pv.user_id = user.id
	      pv.save!
	    end
    end
  end




end


