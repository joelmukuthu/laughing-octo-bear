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

  # record unique visits/views/impressions on an instance of Mission
  is_impressionable :counter_cache => true, :column_name => :views_cache

  def views
    self.views_cache
  end
end
