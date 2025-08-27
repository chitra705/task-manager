class CreateEmps < ActiveRecord::Migration[7.1]
  def change
    create_table :emps do |t|

      t.string :name
      t.date :dob
      t.string :mobile
      t.string :email
      t.text :address
      t.string :location
      t.string :blood_group
      t.integer :status
      t.references :access_role, polymorphic:true
      t.references :user, polymorphic:true


      t.timestamps
    end
  end

  
end
