class AddcoltouserLog1 < ActiveRecord::Migration[7.1]
  def change
    add_column :user_logs, :last_active_time, :datetime
  end
end
