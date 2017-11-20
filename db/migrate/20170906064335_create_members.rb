class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :email
      t.string :before
      t.string :name
      t.integer :rocket
      t.string :phone
      t.integer :follower
      t.string :comment
      t.date :date
      t.date :permit
      t.boolean :active
      t.integer :product_id
      t.timestamps
    end
  end
end
