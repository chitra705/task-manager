class CreateUserBreakLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_break_logs do |t|
      t.datetime :break_in
      t.datetime :break_out
      t.references :user

      t.timestamps
    end
  end
end
