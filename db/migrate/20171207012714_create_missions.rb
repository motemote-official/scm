class CreateMissions < ActiveRecord::Migration[5.1]
  def change
    create_table :missions do |t|
      t.string :content
      t.date :date
      t.belongs_to :rocket, index: true, foriegn_key: true
      t.timestamps
    end
  end
end
