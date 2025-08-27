class CreateMarkettingTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :marketting_teams do |t|
      t.references :team_list, polymorphic:true
      t.references :emp, polymorphic:true
      t.references :project_task, polymorphic:true
      t.datetime :due_date

      t.timestamps
    end
  end
end
