class CreateUserLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_logs do |t|
      t.references :user, polymorphic:true
      t.datetime :check_in
      t.datetime :check_out
      t.date :log_date
      t.datetime :login_time
      t.datetime :logout_time
      t.string   :session_ip_address
      t.datetime :inactive_time
      t.string   :location
      t.datetime :break_time

      t.timestamps
    end
  end
end
