class CreateMissionFlags < ActiveRecord::Migration
  def change
    create_table :mission_flags do |t|
      t.references :mission, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
