class Command
  def self.run(from, command)
    if command.start_with?('fb post')
      user = User.get(phone_number: from)
      graph = Koala::Facebook::API.new(user.fb_access_token)
      post = command.gsub(/^fb post /, '')

      graph.put_wall_post(post)
    elsif command.start_with?('weather')
      location = command.gsub(/^weather /, '')
      barometer = Barometer.new(location)
      weather = barometer.measure

      "Today, the temperature is #{weather.current.temperature.f}."
    elsif command == 'calc'
      eval command
    elsif command == 'btc update'
      coinbase = Coinbase::Client.new(ENV['CB_ID'], ENV['CB_SECRET'])
      "Bitcoin is #{coinbase.buy_price(1).format} today."
    else
      "Command unrecognized."
    end
  end
end
