class CreateRocketPics < ActiveRecord::Migration[5.1]
  def change
    create_table :rocket_pics do |t|
      t.string :img
      t.belongs_to :rocket_regram, index: true, foriegn_key: true
      t.timestamps
    end
  end
end
