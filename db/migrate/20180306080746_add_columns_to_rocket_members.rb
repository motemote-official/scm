class AddColumnsToRocketMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :rocket_members, :pass, :integer, default: 0
  end
end
