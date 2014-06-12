class Mission::Torch < ActiveRecord::Base
  belongs_to :mission
  belongs_to :torcher,
              class_name: 'User',
              foreign_key: 'user_id'
end
