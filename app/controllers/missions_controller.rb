class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy, :flag]
  before_action :authenticate_user!, only: [:show, :new, :edit, :create, :update, :destroy, :flag]
  before_action :set_categories, only: [:new, :edit]

  # TODO: I18n flash messages

  # GET /missions
  # GET /missions.json
  def index
    # TODO: rules for featured missions: no flags, image correct size, 
    # TODO later: featured only approved by admin
    filter = params[:filter] || 'featured'
    case filter
    when 'featured'
      @listed = Mission.all
      @showcased = Mission.where.not(image: nil).limit(5)
    end
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
    # one has to be signed in to view a mission, so it's safe to use the session hash
    # as a filter for unique views
    impressionist @mission, "viewed by #{current_user.id}", :unique => [:session_hash]
  end

  # GET /missions/new
  def new
    @mission = Mission.new
  end

  # GET /missions/1/edit
  def edit
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)
    @mission.owner = current_user

    respond_to do |format|
      if @mission.save
        format.html { redirect_to @mission, notice: 'Mission was successfully created.' }
        format.json { render :show, status: :created, location: @mission }
      else
        format.html { render :new }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    respond_to do |format|
      if @mission.update(mission_params)
        format.html { redirect_to @mission, notice: 'Mission was successfully updated.' }
        format.json { render :show, status: :ok, location: @mission }
      else
        format.html { render :edit }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html { redirect_to missions_url }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /missions/1/flag
  # PATCH/PUT /missions/1/flag.json
  def flag
    respond_to do |format|
      if @mission.flagged_by?(current_user) || @mission.flags.create(reporter: current_user)
        # TODO: if flagged count exceeds minimum allowed flags till it's taken down automatically,
        # notify user, mark as flagged so no one sees it
        format.html { redirect_to missions_url, notice: t('missions.flagged_as_inappropriate') }
        format.json { head :accepted }
      else
        format.html { redirect_to missions_url, error: t('missions.could_not_flag_as_inappropriate') }
        format.json { head :internal_server_error }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
    end

    def set_categories
      @categories = Category.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_params
      params.require(:mission).permit(:title, :description, :image, :image_cache, :remove_image, 
                                      :category_id, :location, :deadline, :who_can_sponsor, 
                                      :who_can_see_my_name)
    end
end
