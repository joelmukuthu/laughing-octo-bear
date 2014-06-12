module Mission::SponsorshipsHelper
  def can_sponsor_mission? mission
    # TODO: can you sponsor your own mission?
    return false if current_user == mission.owner
    return false if mission.sponsored_by? current_user
    return true if mission.who_can_sponsor == Mission::ANYONE_CAN_SPONSOR
    # TODO: invitees should be automatically added to the list of sponsors
  end

  def sponsor_button_class mission
    return 'activated' if mission.sponsored_by? current_user
    if can_sponsor_mission? mission
      'activate'
    else
      'disabled'
    end
  end
end
