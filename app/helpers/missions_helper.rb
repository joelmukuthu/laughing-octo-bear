module MissionsHelper
  def can_update_mission? mission
    current_user == mission.owner
  end
end
