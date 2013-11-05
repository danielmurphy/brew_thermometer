exec = require('child_process').exec
EventEmitter = require('events').EventEmitter

class Thermometer extends EventEmitter
  constructor: ->
    @temperature = 0
    exec("sudo modprobe w1-gpio")
    exec("sudo modprobe w1-therm")

    setInterval =>
      old_temp = @temperature
      readTemp (temp) =>
        unless old_temp == temp 
          @emit 'temperatureChanged', temp
          @temperature = temp
    , 1000

  readTemp = (callback) ->
   exec "cat /sys/bus/w1/devices/28-000003e6d556/w1_slave", (error, stdout, stderr) ->
    unless error
      temperature = parseInt(stdout.match(/\d{5}/g)[0]) / 1000
      temperature = (temperature * 9/5 + 32).toFixed(1)
      callback(temperature) if callback

module.exports = Thermometer

