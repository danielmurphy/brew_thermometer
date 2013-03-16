socket = io.connect '/'
socket.on 'news', (data) ->
  temperature = data.temperature
  $('#temperature').text temperature