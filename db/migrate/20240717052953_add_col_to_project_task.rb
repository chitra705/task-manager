class AddColToProjectTask < ActiveRecord::Migration[7.1]
  def change
    add_column :project_tasks, :due_start_date, :date
    add_column :project_tasks, :due_end_date, :date

  end
end
