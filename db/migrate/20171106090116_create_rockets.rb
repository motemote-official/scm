class CreateRockets < ActiveRecord::Migration[5.1]
  def change
    create_table :rockets do |t|
      t.integer :unit
      t.integer :term
      t.date :start_date
      t.date :end_date
      t.integer :volume
      t.timestamps
    end
  end
end
