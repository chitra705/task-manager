class Addcoltouser1 < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :team_type, :integer
    add_column :emps, :team_type, :integer
  end
end
