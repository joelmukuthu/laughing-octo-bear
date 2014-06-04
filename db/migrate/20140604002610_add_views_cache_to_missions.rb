class AddViewsCacheToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :views_cache, :integer, default: 0
  end
end
