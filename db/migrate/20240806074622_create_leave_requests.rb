class CreateLeaveRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :leave_requests do |t|
      t.datetime :leave_date
      t.string :leave_reason
      t.references :user
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
