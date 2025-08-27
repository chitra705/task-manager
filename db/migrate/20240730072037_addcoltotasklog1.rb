class Addcoltotasklog1 < ActiveRecord::Migration[7.1]
  def change
    add_column :task_logs, :start_time, :time
    add_column :task_logs, :elapsed_time, :time
  end
end
