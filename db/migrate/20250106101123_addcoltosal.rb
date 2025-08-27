class Addcoltosal < ActiveRecord::Migration[7.1]
  def change
    remove_column :emps, :emp_detail_id
    add_reference :emp_details, :emp
  end
end
