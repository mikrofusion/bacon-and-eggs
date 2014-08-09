BaconAndEggs = require '../dist/index.js'
OAuth = require 'oauth'

expect = require('chai').expect
sinon = require 'sinon'

oauth = undefined
oauthSpy = undefined
connectionSpy = undefined
resultStream = undefined
resultError = undefined

request =
  url: 'url'
  method: 'get'
creds =
  key: 'foo'
  secret: 'bar'
  token: 'biz'
  tokenSecret: 'baz'
statusCode = 200
post_data = null

describe 'connect', ->
  beforeEach ->
    oauthSpy = sinon.stub OAuth, 'OAuth'
    oauth =
      get: ->
      put: ->
      post: ->
      delete: ->
      end: ->
      on: ->

    oauthSpy.returns oauth

  afterEach ->
    oauthSpy.restore()

  describe 'when a url and method are NOT given', ->
    it 'throws an error', ->
      expect(-> BaconAndEggs.connect(creds, null))
        .to.throw('request obj must include url and method')

  describe 'when a method is given but NOT a "get", "put", "post", or "delete"', ->
    it 'throws an error', ->
      expect(-> BaconAndEggs.connect(creds, {url:request.url, method:'blah'}))
        .to.throw('given an invalid http method')

  describe 'when a key, secret, token, and tokenSecret are NOT given', ->
    it 'throws an error', ->
      expect(-> new BaconAndEggs.connect(null, null))
        .to.throw('creds must include key, method, token, and tokenSecret')

  describe 'when a url, token, and token secret are given', ->
    beforeEach ->
      connectionSpy = sinon.stub oauth, request.method
      connectionSpy.returns {
        end: ->
        on: (event, callback) ->
          callback { statusCode: statusCode }
      }

      BaconAndEggs.connect creds, request

    afterEach ->
      connectionSpy.restore()

    describe 'and a key and secret are given', ->
      it 'creates a new oauth object with the given key and secret', ->
        expect(oauthSpy.lastCall.args[2]).to.equal creds.key
        expect(oauthSpy.lastCall.args[3]).to.equal creds.secret

    describe 'when method is a get', ->
      describe 'when no params or contentType are given', ->
        before ->
          request.method = 'get'

        it 'does a get request against the oauth object with the given url, token, and tokenSecret', ->
          expect(connectionSpy.calledWith(request.url, creds.token, creds.tokenSecret, null)).to.equal true

      describe 'when a params is given with a contentType', ->
        # TODO

      describe 'when a params is given with no contentType', ->
        # TODO

    describe 'when method is a delete', ->
      describe 'when no params or contentType are given', ->
        before ->
          request.method = 'delete'

        it 'does a delete request against the oauth object with the given url, token, and tokensecret', ->
          expect(connectionSpy.calledWith(request.url, creds.token, creds.tokenSecret, null)).to.equal true

      describe 'when a params is given with a contentType', ->
        # TODO

      describe 'when a params is given with no contentType', ->
        # TODO

    describe 'when method is a put', ->
      before ->
        request.method = 'put'
        request.params = 'bar'
        request.contentType = 'application/json'

      it 'does a put request against the oauth object with the given url, token, and tokenSecret', ->
        expect(connectionSpy.calledWith(request.url, creds.token, creds.tokenSecret, request.params, request.contentType, null)).to.equal true

    describe 'when method is a post', ->
      before ->
        request.method = 'post'
        request.params = 'foo'
        request.contentType = 'application/x-www-form-urlencoded'

      it 'does a post request against the oauth object with the given url, token, and tokenSecret', ->
        expect(connectionSpy.calledWith(request.url, creds.token, creds.tokenSecret, request.params, request.contentType, null)).to.equal true

    describe 'when the response gives a status code other than 200', ->
      before ->
        statusCode = 403

      # TODO

    describe 'when the response gives a status code of 200', ->
      before ->
        statusCode = 200

      # TODO
