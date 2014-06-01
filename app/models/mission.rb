class Mission < ActiveRecord::Base
  CATEGORIES = [
    ['Lifestyle', 0]
  ]

  validates :title, presence: true

  mount_uploader :image, ImageUploader

  belongs_to :user
end
