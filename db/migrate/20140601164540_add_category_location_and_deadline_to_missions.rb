class AddCategoryLocationAndDeadlineToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :category_id, :integer
    add_column :missions, :location, :string
    add_column :missions, :deadline, :date
  end
end
