class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|

      t.string :title
      t.text :content
      t.integer :category

      t.timestamps
    end
  end
end
