class CreateRegrams < ActiveRecord::Migration[5.1]
  def change
    create_table :regrams do |t|
      t.date :date
      t.text :content
      t.string :img
      t.string :url
      t.references :member
      t.references :product
      t.references :timepool
      t.timestamps
    end
  end
end
