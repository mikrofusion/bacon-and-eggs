# Read the Examples section of the README for detailed instructions
# on running the examples.

# This example will connect to the streaming api and stream a
# list of give statuses filtering on the word 'funny'

BaconAndEggs = require '../dist/index.js'
creds = require('./helper.coffee').creds

stream = BaconAndEggs.toEventStream(
  creds
  BaconAndEggs.TWITTER_STREAMING_API_POST_STATUSES_FILTER
  { track: 'funny' }
)

stream.onError (response) ->
  console.log 'Error:', response

stream.log()
