class CreatePics < ActiveRecord::Migration[5.1]
  def change
    create_table :pics do |t|
      t.string :img
      t.belongs_to :regram, index: true, foriegn_key: true
      t.timestamps
    end
  end
end
