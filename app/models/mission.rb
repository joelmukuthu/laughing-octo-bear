class Mission < ActiveRecord::Base

  ANYONE_CAN_SPONSOR = 1
  ONLY_INVITED_FRIENDS_CAN_SPONSOR = 2

  ANYONE_CAN_SEE_MY_NAME = 1
  ONLY_SPONSORS_CAN_SEE_MY_NAME = 2

  validates_presence_of :title, :category_id

  mount_uploader :image, ImageUploader

  belongs_to :owner,
              class_name: 'User',
              foreign_key: 'user_id'

  belongs_to :category

  has_many :flags

  has_many :sponsorships, dependent: :destroy

  # record unique visits/views/impressions on an instance of Mission
  is_impressionable :counter_cache => true, :column_name => :views_cache

  alias_attribute :reason, :description

  scope :flagged, -> { joins(:flags).uniq }

  scope :not_flagged, -> { where.not(id: Flag.select(:mission_id).uniq) }

  scope :flagged_by, ->(user) { flagged.where(mission_flags: {user_id: user.id}) }

  # TODO: should we also add .references for :category and :owner?
  default_scope { includes(:category, :owner, :flags, :sponsorships) }

  # using .where on this .includes forces AR to use .references which then translates to:
  # missions which have been flagged but not by this user. that's not what we want. instead we'll
  # fetch all missions and filter in the application layer
  # scope :not_flagged_by, ->(user) { includes(:flags).where.not(mission_flags: {user_id: user.id}) }

  def views
    self.views_cache
  end

  def flagged_by? user
    # TODO: run benchmarks. Which is better, loop through all the flags (note these are already loaded 
    # by the default .includes scope) or send a separate query here
    # flag = self.flags.find_by reporter: user
    # flag.nil? ? false : true
    self.flags.each do |flag|
      return true if flag.reporter == user
    end
    false
  end

  def sponsored_by? user
    # TODO: run benchmarks. Which is better, loop through all the sponsorships (note these are already loaded 
    # by the default .includes scope) or send a separate query here
    # sponsorship = self.sponsorships.find_by sponsor: user
    # sponsorship.nil? ? false : true
    self.sponsorships.each do |sponsorship|
      return true if sponsorship.sponsor == user
    end
    false
  end
end
