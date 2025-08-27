class PayslipValue < ApplicationRecord
	belongs_to :sal_payslip, polymorphic:true
	belongs_to :user

	


end