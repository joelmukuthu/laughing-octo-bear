module MissionsHelper

  def can_view_missions?
    user_signed_in?
  end

  def can_create_missions?
    user_signed_in?
  end

  def can_update_missions?
    user_signed_in?
  end

  def can_update_mission? mission
    can_update_missions? && current_user && current_user == mission.owner
  end
end
