class CreateEmpDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :emp_details do |t|
      t.decimal :slary_per_day
      t.decimal :basic_salary
      
      t.timestamps
    end
  end
end
