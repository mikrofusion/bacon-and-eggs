BaconAndEggs = require('../dist/index.js')

creds =
  key: USER_KEY
  secret: USER_SECRET
  token: USER_TOKEN
  token_secret: USER_TOKEN_SECRET

TWITTER_API     = 'https://api.twitter.com/1.1/'

connection = BaconAndEggs.TwitterConnection 'https://userstream.twitter.com/1.1/user.json', creds.key, creds.secret
BaconAndEggs.TwitterStream(connection).log()
