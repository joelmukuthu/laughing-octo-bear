class Mission::SponsorshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission
  before_action :ensure_current_user_can_sponsor_mission!, only: :create
  before_action :ensure_current_user_already_sponsors_mission!, only: :destroy

  # POST /missions/:mission_id/sponsorship
  # POST /missions/:mission_id/sponsorship.json
  def create
    if @mission.sponsored_by? current_user
      return respond_to do |format|
        format.html { redirect_to mission_path(@mission) }
        format.json { head :no_content }
      end
    end
    @mission.sponsorships.create sponsor: current_user
    respond_to do |format|
      # TODO: notification and activity
      format.html { redirect_to mission_path(@mission), notice: t('missions.sponsored_successfully') }
      format.json { render json: { count: @mission.sponsorships.count } }
    end
  end

  # DELETE /missions/:mission_id/sponsorship
  # DELETE /missions/:mission_id/sponsorship.json
  def destroy
    sponsorhip = @mission.sponsorships.find_by sponsor: current_user
    sponsorhip.destroy
    respond_to do |format|
      format.html { redirect_to mission_path(@mission) }
      format.json { render json: { count: @mission.sponsorships.count } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:mission_id])
    end

    def ensure_current_user_can_sponsor_mission!
      # TODO: can you sponsor your own mission?
      if current_user == @mission.owner
        redirect_to missions_url, alert: t('missions.cannot_sponsor_own_mission')
      elsif @mission.sponsored_by? current_user
        redirect_to missions_url, notice: t('missions.already_sponsoring_mission')
      elsif @mission.who_can_sponsor != Mission::ANYONE_CAN_SPONSOR
        redirect_to missions_url, flash: { error: t('missions.edit_sponshorship_denied') }
      end
    end

    def ensure_current_user_already_sponsors_mission!
      if not @mission.sponsored_by? current_user
        redirect_to missions_url, flash: { error: t('missions.destroy_sponshorship_denied') }
      end
    end
end

