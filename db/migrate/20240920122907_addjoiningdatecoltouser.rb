class Addjoiningdatecoltouser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :joining_date, :date
    add_column :users, :designation, :string
    add_column :emps, :joining_date, :date
    add_column :emps, :designation, :string    
  end
end
