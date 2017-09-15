class AddDateToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :date, :date, default: "2017-05-22"
  end
end
