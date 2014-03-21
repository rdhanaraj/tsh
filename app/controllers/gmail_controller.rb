class GmailController < ApplicationController
  def index
    client = OAuth2::Client.new(ENV['GM_ID'], ENV['GM_SECRET'],
      site: 'https://accounts.google.com',
      authorize_url: '/o/oauth2/auth',
      token_url: '/o/oauth2/token'
    )
    redirect_to client.auth_code.authorize_url(redirect_uri: "#{root_url}gmail/callback", scope: 'https://mail.google.com/ https://www.googleapis.com/auth/userinfo.email')
  end

  def callback
    client = OAuth2::Client.new(ENV['GM_ID'], ENV['GM_SECRET'],
      site: 'https://accounts.google.com',
      authorize_url: '/o/oauth2/auth',
      token_url: '/o/oauth2/token'
    )
    access_token = client.auth_code.get_token(params[:code], redirect_uri: "#{root_url}gmail/callback")
    email = access_token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed
    current_user.update(gm_access_token: access_token.token, gm_email: email['data']['email'])

    redirect_to root_path
  end
end
