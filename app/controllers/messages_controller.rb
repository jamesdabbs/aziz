class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    if params[:AccountSid] != ENV.fetch("TWILIO_ACCOUNT_SID")
      raise "Unexpected message sender"
    end

    message = Message.create!(
      from: params[:From],
      body: params[:Body]
    )

    imposition = Imposition.create!(
      message: message,
      contact: params[:From],
      body:    params[:Body]
    ).notify!

    message.reply "Roger! Keeping it down momentarily ..."

    head :no_content
  end
end
