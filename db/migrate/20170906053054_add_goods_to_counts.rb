class AddGoodsToCounts < ActiveRecord::Migration[5.1]
  def change
    add_column :counts, :goods, :boolean, default: false
  end
end
