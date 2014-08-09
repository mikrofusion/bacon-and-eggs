exports.toEventStream = (creds, args...) ->
  if args[0].url?
    [first, params] = args
    { method, url } = first
    requestObject = { method:method, url:url, params: params }
  else
    [ method, resource, params ] = args
    requestObject = request(method, resource, params)

  connection = connect(creds, requestObject)
  stream(connection)

# REST API:  https://dev.twitter.com/docs/api/1.1
request = (method, resource, params) ->
  {
    url: "https://api.twitter.com/1.1/#{resource}.json"
    method: method
    params: params
  }

# GET user
# API:  https://dev.twitter.com/docs/api/1.1/get/user
# Streams messages for a single user, as described in User streams.
exports.TWITTER_STREAMING_API_GET_USER =
  url: 'https://userstream.twitter.com/1.1/user.json'
  method: 'get'

# GET site
# API: https://dev.twitter.com/docs/api/1.1/get/site
exports.TWITTER_STREAMING_API_GET_SITE =
  url: 'https://sitestream.twitter.com/1.1/site.json'
  method: 'get'

# GET statuses/sample
# API: https://dev.twitter.com/docs/api/1.1/get/statuses/sample
exports.TWITTER_STREAMING_API_GET_STATUSES_SAMPLE =
  url: 'https://stream.twitter.com/1.1/statuses/sample.json'
  method: 'get'

# GET statuses/firehose
# API: https://dev.twitter.com/docs/api/1.1/get/statuses/firehose
# NOTE: This endpoint requires special permission to access.
exports.TWITTER_STREAMING_API_GET_STATUSES_FIREHOSE =
  url: 'https://stream.twitter.com/1.1/statuses/firehose.json'
  method: 'get'

# POST statuses/filter
# API: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
# NOTE: At least one predicate parameter (follow, locations, or track)
# must be specified in the POST body.
exports.TWITTER_STREAMING_API_POST_STATUSES_FILTER =
  url: 'https://stream.twitter.com/1.1/statuses/filter.json'
  method: 'post'

