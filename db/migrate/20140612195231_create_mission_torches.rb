class CreateMissionTorches < ActiveRecord::Migration
  def change
    create_table :mission_torches do |t|
      t.references :mission, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
