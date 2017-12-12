class AddMissionToRocket < ActiveRecord::Migration[5.1]
  def change
    add_column :rockets, :mission, :integer, default: 0
  end
end
