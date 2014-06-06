class AddProgressAndAccomplishedToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :progress, :tinyint, default: 0
    add_column :missions, :accomplished, :boolean, default: false
  end
end
