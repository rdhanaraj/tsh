class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    response = Twilio::TwiML::Response.new do |r|
      # responses = Command.run(params[:Body], from: params[:From])

      responses = ["hi", "hi", "hi"]

      responses.each do |res|
        r.Sms res
      end
    end

    render xml: response.text
  end
end
