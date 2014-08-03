BaconAndEggs = require('../dist/index.js')

creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  token_secret:  process.env.TWITTER_USER_TOKEN_SECRET

TWITTER_API     = 'https://api.twitter.com/1.1/'

BaconAndEggs.TwitterConnection 'https://userstream.twitter.com/1.1/user.json', creds, (err, connection) ->
  throw err if err

  stream = BaconAndEggs.TwitterStream(connection)
  stream.onValue (x) -> console.log x
