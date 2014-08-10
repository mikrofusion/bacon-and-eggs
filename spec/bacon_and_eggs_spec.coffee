BaconAndEggs = require '../dist/index.js'

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
