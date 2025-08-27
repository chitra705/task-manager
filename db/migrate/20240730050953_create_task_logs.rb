class CreateTaskLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :task_logs do |t|
      t.integer :status
      t.references :project_task, polymorphic:true
      t.references :user
      t.time :active
      t.time :pause
      t.timestamps
    end
  end
end
