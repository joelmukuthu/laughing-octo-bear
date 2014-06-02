class AddPrivacyToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :who_can_sponsor, :tinyint
    add_column :missions, :who_can_see_my_name, :tinyint
  end
end
