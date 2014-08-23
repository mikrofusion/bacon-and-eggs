BaconAndEggs = require '../dist/index.js'

Bacon = require 'baconjs'
expect = require('chai').expect
sinon = require 'sinon'

describe 'parseArgs', ->
  describe 'when given creds, method, url, and params', ->
    response = undefined
    before ->
      response = BaconAndEggs.parseArgs 'method', 'resource', 'params'

    it 'sends connect creds and a request object containing the method resource and params', ->
      expect(response).to.deep.eq { url: 'https://api.twitter.com/1.1/resource.json', method: 'method', params: 'params' }

  describe 'when given creds and a streaming endpoint', ->
    response = undefined
    before ->
      response = BaconAndEggs.parseArgs BaconAndEggs.TWITTER_STREAMING_API_GET_USER, 'params'

    it 'sends connect creds and a request object containing the method resource and params', ->
      expect(response).to.deep.eq { url: 'https://userstream.twitter.com/1.1/user.json', method: 'get', params: 'params' }

describe 'toRateLimitedEventStream', ->

  response = undefined
  error = undefined
  rate_limit_remaining = undefined
  rate_limit_reset = undefined

  beforeEach ->
    response = undefined
    error = undefined
    creds = {}
    sinon.stub BaconAndEggs, 'toEventStream', (creds, args...) ->
      [ method, resource, params ] = args

      if resource == 'application/rate_limit_status'
        Bacon.once(
          resources:
            application:
              '/application/rate_limit_status':
                remaining: rate_limit_remaining
                reset: rate_limit_reset
            foo:
              '/foo/bar':
                remaining: rate_limit_remaining
                reset: rate_limit_reset
        )
      else
        Bacon.once 'foo'

    BaconAndEggs.toRateLimitedEventStream(creds, 'get', 'foo/bar').onValue (val) ->
      response = val

    BaconAndEggs.toRateLimitedEventStream(creds, 'get', 'foo/bar').onError (val) ->
      error = val

  afterEach ->
    BaconAndEggs.toEventStream.restore()

  describe 'when the user is rate limited', ->
    before ->
      rate_limit_remaining = 0
      rate_limit_reset = 0

    it 'returns an error indicating the request has hit its rate limit', ->
      expect(response).to.eq undefined
      expect(error.message).to.include 'rate limit reached'
      expect(error.reset).to.be.a 'number'

  describe 'when the user is NOT rate limited', ->
    before ->
      rate_limit_remaining = 5

    it 'returns the response of the original request', ->
      expect(response).to.eq 'foo'
      expect(error).to.eq undefined
