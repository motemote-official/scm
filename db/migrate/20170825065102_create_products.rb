class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.string :kind
      t.integer :price
      t.timestamps
    end
  end
end
