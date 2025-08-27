class CreateTimeValues < ActiveRecord::Migration[7.1]
  def change
    create_table :time_values do |t|
      t.time :time
      t.integer :time_value, default:0

      t.timestamps
    end
  end
end
