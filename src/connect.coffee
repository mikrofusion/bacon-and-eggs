OAuth = require 'oauth'
querystring = require 'querystring'

TWITTER_OAUTH_REQUEST = 'https://twitter.com/oauth/request_token'
TWITTER_OAUTH_ACCESSS = 'https://twitter.com/oauth/access_token'

connect = (creds, request) ->
  { key, secret, token, tokenSecret } = creds if creds?

  if !key? || !secret? || !token? || !tokenSecret?
    throw new Error "creds must include key, method, token, and tokenSecret"

  oauth = new OAuth.OAuth TWITTER_OAUTH_REQUEST, TWITTER_OAUTH_ACCESSS,
                          key, secret, '1.0A', null, 'HMAC-SHA1'

  { url, method, params, contentType } = request if request?

  if !url? || !method?
    throw new Error "request obj must include url and method"

  urlParams = ""
  urlParams = "?#{querystring.stringify(params)}" if params?

  contentType ?= 'application/json'

  if method.toLowerCase() == 'get'
    connection = oauth.get "#{url}#{urlParams}", token, tokenSecret, null
  else if method.toLowerCase() == 'delete'
    connection = oauth.delete "#{url}#{urlParams}",
      token, tokenSecret, null
  else if method.toLowerCase() == 'put'
    connection = oauth.put url, token,
      tokenSecret, params, contentType, null
  else if method.toLowerCase() == 'post'
    connection = oauth.post url,
      token, tokenSecret, params, contentType, null
  else
    throw new Error "given an invalid http method"

  connection.end()

  Bacon.fromBinder (sink) ->
    connection.on 'response', (response) ->
      if response.statusCode != 200
        sink new Bacon.Error 'failed with HTTP status ' + response.statusCode
      else
        response.on 'data', (data) ->
          sink data
        response.on 'end', () ->
          sink '\r\n'
