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

  is_impressionable # record unique visits/views/impressions on an instance of Mission

  def views
    # one has to be signed in to view a mission, so it's safe to use the session hash as a filter
    # for unique views
    impressionist_count(:filter=>:session_hash)
  end
end
