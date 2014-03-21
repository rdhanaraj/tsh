class FacebookController < ApplicationController
  def index
    session['oauth'] = Koala::Facebook::OAuth.new(ENV['FB_ID'], ENV['FB_SECRET'], "#{root_url}facebook/callback")
    redirect_to session['oauth'].url_for_oauth_code(scope: 'manage_notifications,publish_actions')
  end

  def callback
    current_user.update(fb_access_token: session['oauth'].get_access_token(params[:code]))
    redirect_to root_path
  end
end
