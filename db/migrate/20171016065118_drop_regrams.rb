class DropRegrams < ActiveRecord::Migration[5.1]
  def change
    drop_table :regrams
  end
end
