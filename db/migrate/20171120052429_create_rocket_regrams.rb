class CreateRocketRegrams < ActiveRecord::Migration[5.1]
  def change
    create_table :rocket_regrams do |t|
      t.date :date
      t.text :content
      t.string :img
      t.string :url
      t.integer :regram_at
      t.belongs_to :rocket
      t.belongs_to :rocket_member
      t.belongs_to :product
      t.timestamps
    end
  end
end
