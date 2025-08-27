class AddcoltouserLog < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_logs, :active_time
    add_column :user_logs, :active_time, :integer, default: 0
  end
end
