# API docs here:  https://dev.twitter.com/docs/api/1.1/get/user
exports.requestUserStreaming = (params) ->
  {
    url: 'https://userstream.twitter.com/1.1/user.json'
    method: 'get'
    params: params
  }

# API docs here: https://dev.twitter.com/docs/api/1.1/get/site
exports.requestSiteStreaming = (params) ->
  {
    url: 'https://sitestream.twitter.com/1.1/site.json'
    method: 'get'
    params: params
  }

# API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/sample
exports.requestStatusesSampleStreaming = (params) ->
  {
    url: 'https://stream.twitter.com/1.1/statuses/sample.json'
    method: 'get'
    params: params
  }

# API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/firehose
# NOTE: This endpoint requires special permission to access.
exports.requestStatusesFirehoseStreaming = (params) ->
  {
    url: 'https://stream.twitter.com/1.1/statuses/firehose.json'
    method: 'get'
    params: params
  }

# API docs here: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
# NOTE: At least one predicate parameter (follow, locations, or track)
# must be specified in the POST body.
exports.requestStatusesFilterStreaming = (params) ->
  {
    url: 'https://stream.twitter.com/1.1/statuses/filter.json'
    method: 'post'
    params: params
  }

exports.request = (method, resource, params) ->
  {
    url: "https://api.twitter.com/1.1/#{resource}.json"
    method: method
    params: params
  }

exports.toEventStream = (creds, request) ->
  connection = connect(creds, request)
  stream(connection)
