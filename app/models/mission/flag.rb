class Mission::Flag < ActiveRecord::Base
  belongs_to :mission
  belongs_to :reporter,
              class_name: 'User',
              foreign_key: 'user_id'
end
