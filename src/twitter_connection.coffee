OAuth = require 'oauth'

TWITTER_OAUTH_REQUEST = 'https://twitter.com/oauth/request_token'
TWITTER_OAUTH_ACCESSS = 'https://twitter.com/oauth/access_token'

exports.TwitterConnection = (request, creds, post_data, callback) ->
  { url, method } = request if request

  if !url? || !method?
    throw new Error "TwitterConnection request obj must include url and method"

  { key, secret, token, token_secret } = creds if creds

  if !key? || !method? || !token? || !token_secret?
    throw new Error "TwitterConnection creds obj must include key, method," +
                    " token, and token_secret"

  { content_type, body } = post_data if post_data?

  if typeof callback != "function"
    throw new Error "TwitterConnection requires a callback"

  oauth = new OAuth.OAuth TWITTER_OAUTH_REQUEST, TWITTER_OAUTH_ACCESSS,
                          key, secret, '1.0A', null, 'HMAC-SHA1'

  if method.toLowerCase() == 'get'
    connection = oauth.get url, token, token_secret, null
  else if method.toLowerCase() == 'delete'
    connection = oauth.delete url, token, token_secret, null
  else if method.toLowerCase() == 'put'
    connection = oauth.put url, token, token_secret, body, content_type, null
  else if method.toLowerCase() == 'post'
    connection = oauth.post url, token, token_secret, body, content_type, null
  else
    throw new Error "TwitterConnection given an invalid http method"

  connection.end()

  connection.on 'response', (response) ->
    if response.statusCode != 200
      err = new Error 'TwitterConnection failed with HTTP status ' +
                      response.statusCode
      callback err, null
    else
      callback null, Bacon.fromEventTarget response, 'data'

# GET user
# API docs here:  https://dev.twitter.com/docs/api/1.1/get/user
# Streams messages for a single user, as described in User streams.
exports.TWITTER_STREAMING_API_GET_USER =
  url: 'https://userstream.twitter.com/1.1/user.json'
  method: 'get'

# GET site
# API docs here: https://dev.twitter.com/docs/api/1.1/get/site
exports.TWITTER_STREAMING_API_GET_SITE =
  url: 'https://sitestream.twitter.com/1.1/site.json'
  method: 'get'

# GET statuses/sample
# API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/sample
exports.TWITTER_STREAMING_API_GET_STATUSES_SAMPLE =
  url: 'https://stream.twitter.com/1.1/statuses/sample.json'
  method: 'get'

# GET statuses/firehose
# API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/firehose
# NOTE: This endpoint requires special permission to access.
exports.TWITTER_STREAMING_API_GET_STATUSES_FIREHOSE =
  url: 'https://stream.twitter.com/1.1/statuses/firehose.json'
  method: 'get'

# POST statuses/filter
# API docs here: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
# NOTE: At least one predicate parameter (follow, locations, or track)
# must be specified in the POST body.
exports.TWITTER_STREAMING_API_POST_STATUSES_FILTER =
  url: 'https://stream.twitter.com/1.1/statuses/filter.json'
  method: 'post'
