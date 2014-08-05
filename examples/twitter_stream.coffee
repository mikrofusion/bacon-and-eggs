# Read the Examples section of the README for detailed instructions
# on running the examples.

# This example will connect to the streaming api and stream a
# list of give statuses filtering on the word 'funny'

BaconAndEggs = require('../dist/index.js')

require('dotenv').load()

creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  token_secret:  process.env.TWITTER_USER_TOKEN_SECRET


request = BaconAndEggs.TWITTER_STREAMING_API_POST_STATUSES_FILTER

post_data =
  body: { track: 'funny' }
  content_type: 'application/json'

BaconAndEggs.TwitterConnection request, creds, post_data, (err, connection) ->
  throw err if err

  stream = BaconAndEggs.TwitterStream(connection)
  stream.onValue (response) ->
    console.log response.text

