class Mission::TorchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission

  # POST /missions/:mission_id/torch
  # POST /missions/:mission_id/torch.json
  def create
    if @mission.torched_by? current_user
      return respond_to do |format|
        format.html { redirect_to mission_path(@mission) }
        format.json { head :no_content }
      end
    end
    @mission.torches.create torcher: current_user
    respond_to do |format|
      # TODO: notification and activity
      format.html { redirect_to mission_path(@mission), notice: t('missions.torch_awarded_successfully') }
      format.json { render json: { count: @mission.torches.count } }
    end
  end

  # DELETE /missions/:mission_id/torch
  # DELETE /missions/:mission_id/torch.json
  def destroy
    torch = @mission.torches.find_by torcher: current_user
    torch.destroy
    respond_to do |format|
      format.html { redirect_to mission_path(@mission) }
      format.json { render json: { count: @mission.torches.count } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:mission_id])
    end
end
