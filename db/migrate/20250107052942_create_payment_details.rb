class CreatePaymentDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_details do |t|
      t.references :user 
      t.references :emp 
      t.float :total_salary
      t.float :given_amount

      t.timestamps
    end
  end
end
