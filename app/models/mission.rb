class Mission < ActiveRecord::Base
  CATEGORIES = [
    ['Lifestyle', 0]
  ]

  ANYONE_CAN_SPONSOR = 1
  ONLY_INVITED_FRIENDS_CAN_SPONSOR = 2

  ANYONE_CAN_SEE_MY_NAME = 1
  ONLY_SPONSORS_CAN_SEE_MY_NAME = 2

  validates_presence_of :title, :category_id

  mount_uploader :image, ImageUploader

  belongs_to :user
end
