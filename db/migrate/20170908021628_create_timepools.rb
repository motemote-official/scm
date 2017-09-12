class CreateTimepools < ActiveRecord::Migration[5.1]
  def change
    create_table :timepools do |t|

      t.string :time

      t.timestamps
    end
  end
end
