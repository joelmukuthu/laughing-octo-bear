class Message < ActiveRecord::Base
  belongs_to :recipient,
              class_name: 'User',
              foreign_key: 'recipient_id'

  belongs_to :sender, 
              class_name: 'User',
              foreign_key: 'sender_id'

  has_many :replies,
            class_name: 'Message',
            foreign_key: 'reply_to'

  belongs_to :original,
              class_name: 'Message',
              foreign_key: 'reply_to'            


  validates_presence_of :body, :sender_id, :recipient_id

  def read?
    !self.read_at?
  end

  def unread?
    self.read_at?
  end
end
