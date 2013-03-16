util = require 'util',
  twitter = require 'twitter'

twit = new twitter
  consumer_key: 'cFS4XZK5lVQxZVEkXLgpTQ'
  consumer_secret: 'QX9bljIYoB37nmbiQn5kZHsJL766dgz1ovlCQsyVBiA'
  access_token_key: '1256072593-mhydPOUIxAwT7gDPXX0AUhDYoM7OtrklviMnkIZ'
  access_token_secret: 'YO80Tlms8a9nWPvrsKwE5PieJfJynSDik6o3UZPEbCs'

twit.updateStatus 'Hello World!', (data) ->
  console.log(util.inspect(data))
