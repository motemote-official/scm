class AddEmptyToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :empty, :boolean, default: false
  end
end
