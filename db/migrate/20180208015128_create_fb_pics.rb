class CreateFbPics < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_pics do |t|
      t.string :img
      t.string :user_name
      t.belongs_to :facebook, index: true, foriegn_key: true
      t.timestamps
    end
  end
end
