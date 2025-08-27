class Addcoltotlog < ActiveRecord::Migration[7.1]
  def change
    remove_column :task_logs, :active
    add_column :task_logs, :active, :string
  end
end
