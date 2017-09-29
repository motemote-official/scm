class RemoveProductIdToRegrams < ActiveRecord::Migration[5.1]
  def change
    remove_column :regrams, :product_id
  end
end
