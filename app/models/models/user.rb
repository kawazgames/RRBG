class User < ActiveRecord::Base
  has_many :authentications
  devise :trackable, :omniauthable

  def set_for_twitter omniauth
    User.transaction do
      twitter_lock = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'], lock: true)
      if twitter_lock.nil?
        self.authentications.build self.get_twitter_args(omniauth)
      else
        twitter_lock.update_attributes self.get_twitter_args(omniauth)
      end
      self.save!
    end
  end

  def get_twitter_args omniauth
    data = omniauth['extra']['raw_info']
    {
      provider: omniauth['provider'], uid: omniauth['uid'],
      access_token: omniauth['credentials']['token'],
      access_secret: omniauth['credentials']['secret'],
      screen_name: data['screen_name'],
      bio: data['description'],
      image_url: data['profile_image_url'],
      web_url: data['url'],
      last_tid: nil
    }
  end

end
