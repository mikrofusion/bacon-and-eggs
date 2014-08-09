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
  token_secret: 'baz'
statusCode = 200
post_data = null

describe 'TwitterConnection', ->
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
      expect(-> new BaconAndEggs.TwitterConnection(null, creds, null, ->))
        .to.throw('TwitterConnection request obj must include url and method')

  describe 'when a method is given but NOT a "get", "put", "post", or "delete"', ->
      expect(-> new BaconAndEggs.TwitterConnection({url:request.url, method:'blah'}, creds, null, ->))
        .to.throw('TwitterConnection given an invalid http method')

  describe 'when a key, secret, token, and token_secret are NOT given', ->
      expect(-> new BaconAndEggs.TwitterConnection(request, null, null, ->))
        .to.throw('TwitterConnection creds obj must include key, method, token, and token_secret')

  describe 'when a callback function is NOT given', ->
    it 'throws an error', ->
      expect(-> new BaconAndEggs.TwitterConnection(request, creds, null, null))
        .to.throw('TwitterConnection requires a callback')


    describe 'when a url, token, and token secret are given', ->
      beforeEach ->
        connectionSpy = sinon.stub oauth, request.method
        connectionSpy.returns {
          end: ->
          on: (event, callback) ->
            callback { statusCode: statusCode }
        }

        new BaconAndEggs.TwitterConnection request, creds, post_data, (err, result) ->
          resultError = err
          resultStream = result

      afterEach ->
        connectionSpy.restore()

      describe 'and a key and secret are given', ->
        it 'creates a new oauth object with the given key and secret', ->
          expect(oauthSpy.lastCall.args[2]).to.equal creds.key
          expect(oauthSpy.lastCall.args[3]).to.equal creds.secret

      describe 'when method is a get', ->
        before ->
          request.method = 'get'

        it 'does a get request against the oauth object with the given url, token, and token_secret', ->
          expect(connectionSpy.calledWith(request.url, creds.token, creds.token_secret, null)).to.equal true

      describe 'when method is a put', ->
        before ->
          post_data =
            content_type: 'application/json'
            body: 'bar'

          request.method = 'put'

        it 'does a put request against the oauth object with the given url, token, and token_secret', ->
          expect(connectionSpy.calledWith(request.url, creds.token, creds.token_secret, post_data.body, post_data.content_type, null)).to.equal true

      describe 'when method is a post', ->
        before ->
          post_data =
            content_type: 'application/x-www-form-urlencoded'
            body: 'foo'

          request.method = 'post'

        it 'does a post request against the oauth object with the given url, token, and token_secret', ->
          expect(connectionSpy.calledWith(request.url, creds.token, creds.token_secret, post_data.body, post_data.content_type, null)).to.equal true

      describe 'when method is a delete', ->
        before ->
          request.method = 'delete'

        it 'does a delete request against the oauth object with the given url, token, and token_secret', ->
          expect(connectionSpy.calledWith(request.url, creds.token, creds.token_secret, null)).to.equal true

      describe 'when the response gives a status code other than 200', ->
        before ->
          statusCode = 403

        it 'the callback error is an Error object', ->
          expect(resultError.message).to.equal (new Error 'TwitterConnection failed with HTTP status 403').message

        it 'the callback response is null', ->
          expect(resultStream).to.equal null

      describe 'when the response gives a status code of 200', ->
        before ->
          statusCode = 200

        it 'the callback err is null', ->
          expect(resultError).to.equal null

        it 'the callback response is an EventStream object', ->
          expect(resultStream.constructor.name).to.equal 'EventStream'
