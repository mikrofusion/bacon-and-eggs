BaconAndEggs = require '../dist/index.js'
OAuth = require 'oauth'

expect = require('chai').expect
sinon = require 'sinon'

oauth = undefined
oauthSpy = undefined
connectionSpy = undefined
resultStream = undefined
resultError = undefined
url = 'url'
creds =
  key: 'foo'
  secret: 'bar'
  token: 'biz'
  token_secret: 'baz'
statusCode = 200

describe 'TwitterConnection', ->
  describe 'when callback is not a function', ->
    it 'throws an error', ->
      expect(-> new BaconAndEggs.TwitterConnection()).to.throw('TwitterConnection requires a callback')

  describe 'when the callback is a function', ->
    beforeEach ->
      oauthSpy = sinon.stub OAuth, 'OAuth'
      oauth = { get: ->
        end: ->
        on: ->
      }
      oauthSpy.returns oauth

    afterEach ->
      oauthSpy.restore()

    describe 'and a key and secret are given', ->
      beforeEach ->
        new BaconAndEggs.TwitterConnection url, creds, ->

      it 'creates a new oauth object with the given key and secret', ->
        expect(oauthSpy.lastCall.args[2]).to.equal creds.key
        expect(oauthSpy.lastCall.args[3]).to.equal creds.secret

    describe 'and a url, token, and token secret are given', ->
      beforeEach ->
        connectionSpy = sinon.stub oauth, 'get'
        connectionSpy.returns {
          end: ->
          on: (event, callback) ->
            callback { statusCode: statusCode }
        }

        new BaconAndEggs.TwitterConnection url, creds, (err, result) ->
          resultError = err
          resultStream = result

      afterEach ->
        connectionSpy.restore()

      it 'does a get request against the oauth object with the given url, token, and token_secret', ->
        expect(connectionSpy.calledWith(url, creds.token, creds.token_secret, null)).to.equal true

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
