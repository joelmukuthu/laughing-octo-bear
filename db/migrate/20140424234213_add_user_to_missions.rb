class AddUserToMissions < ActiveRecord::Migration
  def change
    add_reference :missions, :user, index: true
  end
end
