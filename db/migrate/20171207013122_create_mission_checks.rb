class CreateMissionChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :mission_checks do |t|
      t.belongs_to :mission
      t.belongs_to :rocket_member
      t.timestamps
    end
  end
end
