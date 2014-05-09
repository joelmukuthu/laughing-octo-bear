class User < ActiveRecord::Base
  TEMP_EMAIL = 'temp@email.com'
  TEMP_EMAIL_REGEX = /temp@email.com/

  # Include default devise modules. Others available are:
  # :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :omniauthable

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  has_many :messages, -> { where deleted_by_recipient: false },
            class_name: 'Message',
            foreign_key: 'recipient_id'

  has_many :sent_messages, -> { where deleted_by_sender: false },
            class_name: 'Message',
            foreign_key: 'sender_id'

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    user = identity.user
    if user.nil?

      # Get the existing user by email if the OAuth provider gives us a verified email
      # If the email has not been verified yet we will force the user to validate it
      email = auth.info.email if auth.info.verified_email
      user = User.where(:email => email).first if email

      # Create the user if it is a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? TEMP_EMAIL : email,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end

      # Associate the identity with the user if not already
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end
    user
  end
end
