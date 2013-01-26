class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :access_token, :access_secret, :screen_name, :bio, :image_url, :web_url, :last_tid
end