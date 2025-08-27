class CreatePayslipValues < ActiveRecord::Migration[7.1]
  def change
    create_table :payslip_values do |t|

      t.string :earnings
      t.float  :earning_amount
      t.string :deductions
      t.float  :deduction_amount
      t.references :user
      t.references :sal_payslip, polymorphic:true

      t.timestamps
    end
    
  end
end
