require('dotenv').load()

exports.creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  tokenSecret:  process.env.TWITTER_USER_TOKEN_SECRET

