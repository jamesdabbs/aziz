from flask import Flask, make_response
import os
import requests

BRIDGE_ID      = os.environ["HUE_BRIDGE_ID"]
ACCESS_TOKEN   = os.environ["HUE_ACCESS_TOKEN"]
CONTACT_NUMBER = os.environ["HUE_CONTACT_NUMBER"]

app = Flask(__name__)

def sendmessage(endpoint, method, body):
  msg = 'clipmessage={ bridgeId: "%s", clipCommand: { url: "/api/0/%s", method: "%s", body: %s } }' % (BRIDGE_ID, endpoint, method, body)
  r = make_response(requests.post(
    'https://www.meethue.com/api/sendmessage',
    params  = {'token':ACCESS_TOKEN},
    headers = {'content-type':'application/x-www-form-urlencoded'},
    data    = msg
  ).text)
  r.mimetype = "application/json"
  return r

@app.route("/", methods=["GET"])
def home():
    return "It works"

@app.route("/stop", methods=["POST"])
def stop():
  return sendmessage("groups/0/action", "PUT", '{"on":true, "sat":255, "hue":0}')

# Something to toggle while debugging ...
@app.route("/go", methods=["POST"])
def go():
  return sendmessage("groups/0/action", "PUT", '{"on":true, "sat":255, "hue":25000}')

if __name__ == "__main__":
      app.run(host='0.0.0.0', debug=True)


