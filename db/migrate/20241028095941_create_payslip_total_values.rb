class CreatePayslipTotalValues < ActiveRecord::Migration[7.1]
  def change
    create_table :payslip_total_values do |t|
      t.float :total_earnings
      t.float :total_deductions
      t.float :net_pay
      t.references :user
      t.references :sal_payslip, polymorphic:true

      t.timestamps
    end

  end
end
