class Mission < ActiveRecord::Base
  CATEGORIES = [
    ['Lifestyle', 0]
  ]

  validates_presence_of :title, :category_id

  mount_uploader :image, ImageUploader

  belongs_to :user
end
