from flask import Flask, request, make_response, render_template
import mandrill
import os
import requests

BRIDGE_ID      = os.environ["HUE_BRIDGE_ID"]
ACCESS_TOKEN   = os.environ["HUE_ACCESS_TOKEN"]

mailer = mandrill.Mandrill(os.environ["MANDRILL_APIKEY"])

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
  return render_template("home.html")

@app.route("/stop", methods=["POST"])
def stop():
  message = {
    "from_email": "aziz@jdabbs.com",
    "from_name": "Aziz",
    "to": [{"email":"jamesdabbs@gmail.com", "name":"James"}],
    "subject": "Lights!",
    "html": """Keep it down!
       <ul>
         <li>IP: %s</li>
         <li>Contact info: %s</li>
         <li>Comments: %s</li>
       </ul>""" % (request.remote_addr, request.form["contact"], request.form["comments"])
  }
  mailer.messages.send(message, async=True)
  return sendmessage("groups/0/action", "PUT", '{"on":true, "sat":255, "hue":0}')

if __name__ == "__main__":
  app.run(host='0.0.0.0', debug=True)

