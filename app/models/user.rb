class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  enum role: [:admin, :user]    
  
  mount_uploader :profile, ProfileUploader   

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(name: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user.first_name = auth.info.name
    user.image = auth.info.image
    user.uid = auth.uid
    user.provider = auth.provider
    user.save
    user
  end
end
