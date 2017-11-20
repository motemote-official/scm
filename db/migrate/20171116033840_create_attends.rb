class CreateAttends < ActiveRecord::Migration[5.1]
  def change
    create_table :attends do |t|
      t.belongs_to :rocket_member
      t.belongs_to :rocket
      t.date :date
      t.integer :status
      t.timestamps
    end
  end
end
