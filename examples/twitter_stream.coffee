# This example will connect to the streaming api and stream a
# list of give statuses filtering on the word 'funny'

BaconAndEggs = require('../dist/index.js')

require('dotenv').load()

# Either export your twitter key, secret, token, and token_secret via
# command line prior to running.
# OR
# Put a .env file at the root of the project with the values to be exported.
#
# Example .env file:
# TWITTER_USER_KEY=YOUR-USER-KEY-HERE
# TWITTER_USER_SECRET=YOUR-USER-SECRET-HERE
# TWITTER_USER_TOKEN=YOUR-USER-TOKEN-HERE
# TWITTER_USER_TOKEN_SECRET=YOUR-USER-TOKEN-SECRET-HERE

creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  token_secret:  process.env.TWITTER_USER_TOKEN_SECRET

# Possible streaming options:

# GET user
# API docs here:  https://dev.twitter.com/docs/api/1.1/get/user
# BaconAndEggs.TWITTER_STREAMING_API_GET_USER
#
# GET site
# API docs here: https://dev.twitter.com/docs/api/1.1/get/site
# BaconAndEggs.TWITTER_STREAMING_API_GET_SITE
#
# GET statuses/sample
# API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/sample
# BaconAndEggs.TWITTER_STREAMING_API_GET_STATUSES_SAMPLE
#
# GET statuses/firehose
# API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/firehose
# NOTE: This endpoint requires special permission to access.
# BaconAndEggs.TWITTER_STREAMING_API_GET_STATUSES_FIREHOSE
#
# POST statuses/filter
# API docs here: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
# NOTE: At least one predicate parameter (follow, locations, or track)
# must be specified in the POST body.
# BaconAndEggs.TWITTER_STREAMING_API_POST_STATUSES_FILTER

request = BaconAndEggs.TWITTER_STREAMING_API_POST_STATUSES_FILTER

post_data =
  body: { track: 'funny' }
  content_type: 'application/json'

BaconAndEggs.TwitterConnection request, creds, post_data, (err, connection) ->
  throw err if err

  stream = BaconAndEggs.TwitterStream(connection)
  stream.onValue (x) ->
    console.log x.text

