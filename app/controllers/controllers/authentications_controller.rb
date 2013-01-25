class AuthenticationsController < ApplicationController
  def callback
    omniauth = request.env['omniauth.auth']
    @authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if @authentication
      @user = @authentication.user
    else
      # New User
      @user = User.new
    end
    @user.set_for_twitter omniauth
    sign_in(:user, @user)
    redirect_to root_url
  end
end