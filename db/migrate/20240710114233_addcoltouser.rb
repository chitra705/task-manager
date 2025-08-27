class Addcoltouser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dob, :date
    add_column :users, :address, :text
    add_column :users, :location, :string
    add_column :users, :blood_group, :string
    add_reference :users, :emp, polymorphic:true
  end
end
