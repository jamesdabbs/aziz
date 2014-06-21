class Light
  include HTTParty
  base_uri "https://www.meethue.com/api"
  default_params token: ENV.fetch("HUE_ACCESS_TOKEN")

  def self.alert!
    call "PUT", "groups/0/action", '{"on":true, "sat":255, "hue":0}'
  end

  private

  def self.call method, endpoint, message
    clip = %|clipmessage={
      bridgeId: "#{ENV.fetch 'HUE_BRIDGE_ID'}",
      clipCommand: {
        url: "/api/0/#{endpoint}",
        method: "#{method}",
        body: #{message}
      }
    }|

    post "/sendmessage", body: clip.squish, verify: false
  end
end
