require 'bundler'
Bundler.require

require './command'

class DmUser
  property :phone_number, String
  property :fb_access_token, String, length: 255
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/tsh')
DataMapper.auto_upgrade!

set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + 'views/'
use Rack::Session::Cookie, secret: ENV['SESSION_SECRET'] || '9a6f62d4510ebd600926a91e52d0094cb68c1852f235addd2fab90a2c1a441da6ceb9835bc8263b00272f0b059eba56b18ae8de627b698cfc17986e6790ea7c3'

get '/' do
  login_required
  haml :index
end

get '/facebook' do
  session['oauth'] = Koala::Facebook::OAuth.new(ENV['FB_ID'], ENV['FB_SECRET'], "#{request.base_url}/facebook/callback")
  redirect session['oauth'].url_for_oauth_code(scope: 'manage_notifications,publish_actions')
end

get '/facebook/callback' do
  current_user.update(fb_access_token: session['oauth'].get_access_token(params[:code]))
  redirect '/'
end

post '/sms/?' do
  response = Twilio::TwiML::Response.new do |r|
    r.Sms Command.run(params[:From], params[:Body])
  end

  response.text
end
