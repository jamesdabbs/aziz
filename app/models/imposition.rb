class Imposition < ActiveRecord::Base
  belongs_to :message

  serialize :metadata, JSON

  def notify!
    Light.alert!

    body = "You've received a complaint from #{contact}. Hopefully the lights already flashed, but I'm sending this email just in case. You should do something."
    Mandrill::API.new.messages.send(
      subject: "Keep It Down!",
      from_name: "Aziz",
      from_email: "aziz@jdabbs.com",
      to: [ { email: "jamesdabbs@gmail.com", name: "James Dabbs" } ],
      text: body,
      html: body
    )
  end
end
