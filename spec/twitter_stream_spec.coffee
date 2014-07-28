BaconAndEggs = require '../dist/index.js'

expect = require('chai').expect
EventEmitter = require('events').EventEmitter

describe "TwitterStream", ->
  twitterStream = null
  eventEmitter = null
  streamResponse = undefined

  sendMessage = (message) ->
    eventEmitter.emit('data', message)

  before ->
    connection = new EventEmitter()
    twitterStream = BaconAndEggs.TwitterStream(connection)
    twitterStream.onValue (val) -> streamResponse = val

    eventEmitter = new EventEmitter()
    connection.emit 'response', eventEmitter

  describe 'when the response is complete (contains a carriage return)', ->
    describe 'and the previous response was complete', ->
      describe 'and the response contains a string of valid JSON', ->
        before ->
          streamResponse = undefined
          sendMessage '{"foo":"bar"}\r\n'

        it 'the value is the JSON equivalent of the string', ->
          expect(streamResponse).to.deep.equal {foo: 'bar'}

      describe 'and the response contains a string of invalid JSON', ->
        before ->
          streamResponse = undefined
          sendMessage '{"foo":}\r\n'

        it 'the value does not change', ->
          expect(streamResponse).to.equal undefined

    describe 'the previous response(s) were incomplete', ->
      before ->
        sendMessage '{"foo":"bar",'
        sendMessage '"biz":"baz"}\r\n'

      it 'the value is the combined JSON equivalent of the responses', ->
        expect(streamResponse).to.deep.equal {foo: 'bar',biz:"baz"}

  describe 'when the response is incomplete (does NOT contain a CR)', ->
    before ->
      streamResponse = undefined
      sendMessage '{"foo":"bar"}'

    it 'the value does not change', ->
      expect(streamResponse).to.equal undefined

