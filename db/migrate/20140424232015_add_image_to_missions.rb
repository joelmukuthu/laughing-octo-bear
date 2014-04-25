class AddImageToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :image, :string
  end
end
