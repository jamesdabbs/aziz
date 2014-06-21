class Message < ActiveRecord::Base
  def reply text
    twilio.messages.create(
      from: ENV.fetch("TWILIO_NUMBER"),
      to:   self.from,
      body: text
    )
  end

  private

  def twilio
    @_twilio ||= Twilio::REST::Client.new(
      ENV.fetch("TWILIO_ACCOUNT_SID"),
      ENV.fetch("TWILIO_AUTH_TOKEN")
    ).account
  end
end
