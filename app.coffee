
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

Thermometer = require('./thermometer')
thermometer = new Thermometer()
thermometer.on 'temperatureChanged', (temp) ->
  io.sockets.emit 'news',
    temperature: temp
 
