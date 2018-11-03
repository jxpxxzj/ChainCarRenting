import flask
from flask import Flask
app = Flask(__name__)

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(17,GPIO.OUT)

@app.route("/on")
def index1():
  GPIO.output(17,GPIO.HIGH)
  return "hello world"
  
  
@app.route("/off")
def index2():
  GPIO.output(17,GPIO.LOW)
  return "hello world"

if __name__ == "__main__":
  app.run(host="0.0.0.0")
