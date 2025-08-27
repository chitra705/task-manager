class CreateAccessRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :access_roles do |t|
      t.integer :name 
      t.references :emp, polymorphic:true

      t.timestamps
    end
  end
end
