# Read the Examples section of the README for detailed instructions
# on running the examples.

# This example will repeatedly connect to the rest API api and return
# updates to a stream containing the result search for tweets with the
# word 'funny' unless the rate limit for that query has been reached

BaconAndEggs = require('../dist/index.js')
Bacon = require 'baconjs'
creds = require('./helper.coffee').creds

interval = new Bacon.Bus()

getFollowers = (frequency) ->
  interval.flatMap (i) ->
    Bacon.fromCallback (i, callback) ->
      setTimeout ->
        f = BaconAndEggs.toRateLimitedEventStream(
          creds,
          'get',
          'search/tweets',
          { q: 'funny' }
        )
        f.onValue (val) ->
          interval.push frequency
          callback(val)
        f.onError (error) ->
          interval.push error.reset
          callback(null)
      , i
    , i

getFollowers(10000).log()
interval.push(0)
