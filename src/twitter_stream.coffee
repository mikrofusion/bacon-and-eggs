Bacon = require 'baconjs'

CARRIAGE_RETURN = '\r\n'

containsCarriageReturn = (str) ->
  str.indexOf(CARRIAGE_RETURN) > -1

stripCarriageReturn = (str) ->
  if containsCarriageReturn(str)
    str.slice 0, str.indexOf(CARRIAGE_RETURN)
  else
    str

bufferToStr = (buf) ->
  buf + ''

isComplete = (data) ->
  data.complete is true

toJSON = (str) ->
  try
    if str.length > 0
      json = JSON.parse(str)
  catch err
    console.log 'Failed to parse string: ' + str
    null

exports.TwitterStream = (connection) ->

  rawData = Bacon.fromEventTarget(connection, 'response').flatMap (response) ->
    Bacon.fromEventTarget response, 'data'

  complete = rawData.map (raw) ->
    containsCarriageReturn bufferToStr(raw)

  both = rawData.zip complete, (raw, complete) ->
    { data: stripCarriageReturn(bufferToStr(raw)), complete: complete }

  data = both.scan '', (prev, chunk) ->
    if not prev? or not prev.data? or isComplete(prev)
      { data: chunk.data, complete: chunk.complete }
    else
      { data: prev.data + chunk.data, complete: chunk.complete }

  data.filter(isComplete)
    .map((data) ->
      toJSON(data.data))
    .filter (x) -> x?
