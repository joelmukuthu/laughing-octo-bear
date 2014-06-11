class Mission::Sponsorship < ActiveRecord::Base
  belongs_to :mission
  belongs_to :sponsor,
              class_name: 'User',
              foreign_key: 'user_id'
end
