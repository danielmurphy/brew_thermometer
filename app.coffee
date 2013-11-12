
###
Module dependencies.
###

require("coffee-script")
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
app = express()
sys = require('sys')
util = require('util')
twitter = require('twitter')

#exec = require('child_process').exec

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", routes.index
server = http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

io = require('socket.io').listen(server)

therm = require('./thermometer')
thermometer = new therm()
thermometer.on 'temperatureChanged', (temp) ->
  exports.currentTemp = temp
  io.sockets.emit 'news',
    temperature: temp
 
tweeter = new twitter
  consumer_key: '9DcuISdlZpaxYnHZF7T5w'
  consumer_secret: 'agGytO7En53IeYjktz7OiNlRk3iSar4L3sz2w5Fwwg8'
  access_token_key: '1256072593-ElKpLbfqsN1ICiLRXSoFoQe48z7PxVltozlmzME'
  access_token_secret: 'B34VUo66q6HszNGuKRxnR77EHg0bYLWKmTPyc6mFgY'

updateStatus = (tweeter, temp) ->
  console.log "Updating twitter with #{temp}"
  if temp?
    date = new Date()
    tweeter.updateStatus "The temperature at #{date.getHours()}:#{date.getMinutes()}:#{date.getSeconds()} is: #{temp}", (data) ->
      console.log 'twitter returned'
      console.log data.errors if data.errors?
  
setTimeout ->
 updateStatus(tweeter, exports.currentTemp)
, 5000

setInterval ->
  updateStatus(tweeter, exports.currentTemp)
, 1000 * 60 * 30
