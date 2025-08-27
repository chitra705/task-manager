class Addcoltotime1 < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_logs, :active_time
    add_column :user_logs, :active_time, :integer
  end
end
