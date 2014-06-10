module MissionsHelper
  def can_update_mission? mission
    current_user == mission.owner
  end

  def can_see_mission_owner_name? mission
    return true if current_user == mission.owner
    return true if mission.who_can_see_my_name == Mission::ANYONE_CAN_SEE_MY_NAME
    return true if mission.sponsored_by? current_user
    # TODO: should we also let invitees who haven't accepted their invitations to see the name too?
  end
end
