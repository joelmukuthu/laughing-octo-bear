class Mission < ActiveRecord::Base
  validates :title, presence: true
end
