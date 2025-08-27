class CreateSalPayslips < ActiveRecord::Migration[7.1]
  def change
    create_table :sal_payslips do |t|

      t.string :pay_period
      t.integer :worked_days
      t.string :employee_name
      t.string :designation
      t.string :department
      t.references :user

      t.timestamps
    end

  end
end
