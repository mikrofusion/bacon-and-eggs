# Read the Examples section of the README for detailed instructions
# on running the examples.

# This example will repeatedly connect to the rest API api and return
# updates to a stream containing the result search for tweets with the
# word 'funny' unless the rate limit for that query has been reached

BaconAndEggs = require('../dist/index.js')
Bacon = require 'baconjs'
creds = require('./helper.coffee').creds

BaconAndEggs.toRepeatedEventStream(
  5000,
  creds,
  'get',
  'search/tweets',
  { q: 'funny' }
).log()
