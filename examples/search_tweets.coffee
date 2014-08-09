# Read the Examples section of the README for detailed instructions
# on running the examples.

# This example will connect to the rest API api and return a
# stream containing the result search for tweets with the word 'funny'

BaconAndEggs = require('../dist/index.js')
creds = require('./helper.coffee').creds

stream = BaconAndEggs.toEventStream creds,
 BaconAndEggs.request 'get', 'search/tweets', { q: 'funny' }

stream.onError (response) ->
  console.log 'Error:', response

stream.log()

