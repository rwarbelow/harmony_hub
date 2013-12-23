class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :validatable, :omniauthable, :omniauth_providers => [:facebook]

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  unless user
	    user = User.create(name:auth.extra.raw_info.name,
	                         provider:auth.provider,
	                         uid:auth.uid,
	                         email:auth.info.email,
	                         password:Devise.friendly_token[0,20]
	                         )
	  end
	  user
	end

	def self.new_with_session(params, session)
    super.tap do |user|
      if email = session["facebook_email"]
        user.email = email if user.email.blank?
      end
    end
  end

  private 

  def user_params
    params.require(:user).permit(
    :provider, :uid, :name, :email, 
    :encrypted_password, :reset_password_token, 
    :reset_password_sent_at, :remember_created_at, 
    :sign_in_count, :current_sign_in_at, :last_sign_in_at, 
    :current_sign_in_ip, :last_sign_in_ip)
  end

end
