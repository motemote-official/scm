class CreateAddColumnsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :filename, :string
    add_column :products, :image, :string
  end
end
