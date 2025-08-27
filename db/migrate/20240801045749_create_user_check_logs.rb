class CreateUserCheckLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_check_logs do |t|
      t.datetime :check_in
      t.datetime :check_out
      t.references :user

      t.timestamps
    end
  end
end
