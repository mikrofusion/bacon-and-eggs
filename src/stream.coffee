Bacon = require 'baconjs'
exports.Bacon = Bacon

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

isValidJSON = (str) ->
  try JSON.parse(str); true catch err then false

toJSON = (str) ->
  if isValidJSON(str)
    JSON.parse(str)
  else
    null

stream = (connection) ->

  isCompleteStream = connection.map (data) ->
    containsCarriageReturn bufferToStr(data)

  connection.zip isCompleteStream, (data, isComplete) ->
    data: stripCarriageReturn(bufferToStr(data)),
    isComplete: isComplete
  .scan '', (prev, chunk) ->
    if not prev? or not prev.data? or prev.isComplete is true
      data: chunk.data
      isComplete: chunk.isComplete
    else
      data: prev.data + chunk.data,
      isComplete: chunk.isComplete
  .filter (data) ->
    isValidJSON(data.data) and data.isComplete is true
  .map (data) ->
    toJSON(data.data)

if process.env.NODE_ENV == 'TEST'
  exports.stream = stream
