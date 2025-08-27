class CreateTeamLists < ActiveRecord::Migration[7.1]
  def change
    create_table :team_lists do |t|
      t.integer :name 
      t.references :team, polymorphic:true

      t.timestamps
    end
  end
end
