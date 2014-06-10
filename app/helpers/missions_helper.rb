module MissionsHelper
  def can_update_mission? mission
    mission.owner == current_user
  end

  def can_see_mission_owner_name? mission
    mission.owner == current_user ||
    mission.who_can_see_my_name == Mission::ANYONE_CAN_SEE_MY_NAME ||
    mission.sponsored_by?(current_user)
    # TODO: should we also let invitees who haven't accepted their invitations to see the name too?
  end

  def can_view_mission? mission
    mission.owner == current_user ||
    mission.who_can_see_my_name == Mission::ANYONE_CAN_SPONSOR ||
    mission.sponsored_by?(current_user)
  end
end
