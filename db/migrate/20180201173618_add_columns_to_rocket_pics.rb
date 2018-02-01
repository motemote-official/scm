class AddColumnsToRocketPics < ActiveRecord::Migration[5.1]
  def change
    add_column :rocket_pics, :user_name, :string
    add_column :rocket_pics, :count_day, :integer
  end
end
