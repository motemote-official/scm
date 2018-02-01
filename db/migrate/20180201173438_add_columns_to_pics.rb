class AddColumnsToPics < ActiveRecord::Migration[5.1]
  def change
    add_column :pics, :user_name, :string
    add_column :pics, :count_day, :integer
  end
end
