
###
Module dependencies.
###

express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
app = express()
sys = require('sys')
exec = require('child_process').exec

exec("modprobe w1-gpio")
exec("modprobe w1-therm")

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

io.sockets.on 'connection', (socket) ->
  socket.emit 'news',
    temperature: "HI!°"

readTemp = ->
  exec "cat /sys/bus/w1/devices/28-000003e6d556/w1_slave", (error, stdout, stderr) =>
    unless error
      temperature = stdout.match(/\d{5}/g)[0]
      io.sockets.emit 'news',
        temperature: temperature

setInterval readTemp, 1000
