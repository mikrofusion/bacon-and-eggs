OAuth = require 'oauth'

TWITTER_OAUTH_REQUEST = 'https://twitter.com/oauth/request_token'
TWITTER_OAUTH_ACCESSS = 'https://twitter.com/oauth/access_token'

exports.TwitterConnection = (url, key, secret, token, token_secret) ->

  oauth = new OAuth.OAuth TWITTER_OAUTH_REQUEST, TWITTER_OAUTH_ACCESSS, key, secret, '1.0A', null, 'HMAC-SHA1'
  connection = oauth.get url, token, token_secret, null
  connection.end()
  connection
