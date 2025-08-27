class CreateProjectTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :project_tasks do |t|

      t.string :title
      t.text :description
      t.integer :status
      t.references :assigned_to, polymorphic: true
      t.references :created_by, polymorphic: true
      t.float :duration
      t.integer :categories
      t.references :team, polymorphic:true

      t.timestamps
    end
  end
end
