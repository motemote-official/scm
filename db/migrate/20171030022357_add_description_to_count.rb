class AddDescriptionToCount < ActiveRecord::Migration[5.1]
  def change
    add_column :counts, :description, :string
  end
end
