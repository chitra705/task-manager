class CreateLeads < ActiveRecord::Migration[7.1]
  def change
    create_table :leads do |t|
      t.references :user
      t.references :emp

      t.integer :status
      t.string  :category
      t.string  :category_name
      t.string  :business_name
      t.text    :address 
      t.string  :city
      t.string  :state
      t.integer :postal_code
      t.string  :country
      t.bigint :phone
      t.string  :email
      t.string  :website
      t.string  :latitude
      t.string  :longitude
      t.string  :map_link
      t.text    :details
      t.string :mobile

      t.timestamps
    end
  end
end
