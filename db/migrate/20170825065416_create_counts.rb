class CreateCounts < ActiveRecord::Migration[5.1]
  def change
    create_table :counts do |t|

      t.integer :count
      t.references :product
      t.date :date
      t.integer :buffer, default: 0

      t.timestamps
    end
  end
end
