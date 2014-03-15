require 'bundler'
Bundler.require

require './command'

class DmUser
  property :phone_number, String
  property :fb_access_token, String, length: 255
  property :gm_access_token, String, length: 255
  property :gm_email, String
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/tsh')
DataMapper.auto_upgrade!

set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + 'views/'
use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'] || '9a6f62d4510ebd600926a91e52d0094cb68c1852f235addd2fab90a2c1a441da6ceb9835bc8263b00272f0b059eba56b18ae8de627b698cfc17986e6790ea7c3'

get '/' do
  login_required
  haml :index
end

get '/docs' do
  haml :docs
end

get '/facebook' do
  session['oauth'] = Koala::Facebook::OAuth.new(ENV['FB_ID'], ENV['FB_SECRET'], "#{request.base_url}/facebook/callback")
  redirect session['oauth'].url_for_oauth_code(scope: 'manage_notifications,publish_actions')
end

get '/facebook/callback' do
  current_user.update(fb_access_token: session['oauth'].get_access_token(params[:code]))
  redirect '/'
end

get '/gmail' do
  client = OAuth2::Client.new(ENV['GM_ID'], ENV['GM_SECRET'],
    site: 'https://accounts.google.com',
    authorize_url: '/o/oauth2/auth',
    token_url: '/o/oauth2/token'
  )
  redirect client.auth_code.authorize_url(redirect_uri: "#{request.base_url}/gmail/callback", scope: 'https://mail.google.com/ https://www.googleapis.com/auth/userinfo.email')
end

get '/gmail/callback' do
  client = OAuth2::Client.new(ENV['GM_ID'], ENV['GM_SECRET'],
    site: 'https://accounts.google.com',
    authorize_url: '/o/oauth2/auth',
    token_url: '/o/oauth2/token'
  )
  access_token = client.auth_code.get_token(params[:code], redirect_uri: "#{request.base_url}/gmail/callback")
  email = access_token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed
  logger.info email
  current_user.update(gm_access_token: access_token.token, gm_email: email['data']['email'])

  redirect '/'
end

post '/sms/?' do
  response = Twilio::TwiML::Response.new do |r|
    responses = Array(Command.run(params[:From], params[:Body]))

    responses.each do |res|
      r.Sms res
    end
  end

  response.text
end
