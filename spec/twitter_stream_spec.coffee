BaconAndEggs = require '../dist/index.js'

expect = require('chai').expect
EventEmitter = require('events').EventEmitter

Bacon = require 'baconjs'

describe 'TwitterStream', ->
  response = undefined
  eventEmitter = null

  sendMessage = (message) ->
    eventEmitter.emit('data', message)

  before ->
    eventEmitter = new EventEmitter()
    stream = Bacon.fromEventTarget(eventEmitter, 'data')

    BaconAndEggs.TwitterStream(stream).onValue (val) ->
      response = val

  describe 'when the response is complete (contains a carriage return)', ->
    describe 'and the previous response was complete', ->
      describe 'and the response contains a string of valid JSON', ->
        before ->
          response = undefined
          sendMessage '{"foo":"bar"}\r\n'

        it 'the value is the JSON equivalent of the string', ->
          expect(response).to.deep.equal {foo: 'bar'}

      describe 'and the response contains a string of invalid JSON', ->
        before ->
          response = undefined
          sendMessage '{"foo":}\r\n'

        it 'the value does not change', ->
          expect(response).to.equal undefined

      describe 'and the response is empty', ->
        before ->
          response = undefined
          sendMessage '\r\n'

        it 'the value does not change', ->
          expect(response).to.equal undefined

    describe 'the previous response(s) were incomplete', ->
      before ->
        sendMessage '{"foo":"bar",'
        sendMessage '"biz":"baz"}\r\n'

      it 'the value is the combined JSON equivalent of the responses', ->
        expect(response).to.deep.equal {foo: 'bar',biz:"baz"}

  describe 'when the response is incomplete (does NOT contain a CR)', ->
    before ->
      response = undefined
      sendMessage '{"foo":"bar"}'

    it 'the value does not change', ->
      expect(response).to.equal undefined

