class CreateRocketMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :rocket_members do |t|
      t.string :email
      t.string :name
      t.string :identity
      t.integer :follower
      t.integer :group
      t.string :homepage
      t.belongs_to :product
      t.belongs_to :rocket
      t.text :application
      t.timestamps
    end
  end
end
