class CreateBefores < ActiveRecord::Migration[5.1]
  def change
    create_table :befores do |t|

      t.string :email
      t.references :member

      t.timestamps
    end
  end
end
