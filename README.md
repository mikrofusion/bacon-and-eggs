# bacon-and-eggs [![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url]

A functional reactive Twitter API client in node.

## Install

```bash
$ npm install bacon-and-eggs
```

### Use
The following shows how to use BaconAndEggs can be used to connect to a Twitter API stream.
In this example we connect to the statuses_filter stream and look for public tweets containing the string 'funny'.

From ```examples/twitter_stream.coffee```:

```
creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  token_secret:  process.env.TWITTER_USER_TOKEN_SECRET

request = BaconAndEggs.TWITTER_STREAMING_API_POST_STATUSES_FILTER

post_data =
  body: { track: 'funny' }
  content_type: 'application/json'

BaconAndEggs.TwitterConnection request, creds, post_data, (err, connection) ->
  throw err if err

  stream = BaconAndEggs.TwitterStream(connection)
  stream.onValue (response) ->
    console.log response.text
```

## API

### TwitterConnection(request, creds, post_data, callback)
####Description:
TwitterConnection creates a baconjs EventStream with raw data returned from one of the Twitter API endpoints.

####Arguments:
``` request ``` - 
A BaconAndEggs Streaming Endpoint (see Streaming Endpoints below).

``` creds ``` - 
An object containing the keys 'key', 'secret', 'token', 'token_secret' with values being your API key, secret, token, and token secret.
If needed, API credentials can be obtained from https://apps.twitter.com/app/new

``` post_data ``` - 
The data to be sent along with your request.  Note: Only applies to get PUT or POST requests.

``` callback ``` - 
Callback method which will be called when the connection has been made.
The callback will take two arguments, ``` error ``` and ``` result ```.
``` error ```will be an Error object if an error has occured (else null).
If no errors have occured, ``` result ``` will be a baconjs stream of data from the connection.

#### Response:
Response is in the form of a callback as specified in the above arguments.

### TwitterStream(connection)
#####Description:
TwitterStream takes a TwitterConnection (raw data EventStream) and transforms it into a baconjs EventStream where the values are JSON responses from the Twitter API.

####Arguments:
``` connection ``` - 
A TwitterConnection object.

####Response:
The return value is a bacon.js EventStream containing JSON responses from the Twitter API.
See the bacon.js documentation for a list of methods that can be applied to a bacon.js EventStream:
https://github.com/baconjs/bacon.js/#common-methods-in-eventstreams-and-properties

### Streaming Endpoints
Streaming endpoints are the set of objects which haveFor convenience, the following set of streaming endpoints are already defined.
Streaming endpoints are the set of streaming API endpoints available to us via Twitter.
are objects with both a 'url' and 'method' key which have been defined in BaconAndEggs for convenience.
The 'url' value is the API endpoint (e.g. 'https://userstream.twitter.com/1.1/user.json').
The 'method' value is an HTTP method (either 'get', 'put', 'post', or 'delete').

``` BaconAndEggs.TWITTER_STREAMING_API_GET_USER ``` - GET user

API docs here:  https://dev.twitter.com/docs/api/1.1/get/user

``` BaconAndEggs.TWITTER_STREAMING_API_GET_SITE ``` - GET site

API docs here: https://dev.twitter.com/docs/api/1.1/get/site

``` BaconAndEggs.TWITTER_STREAMING_API_GET_STATUSES_SAMPLE ``` - GET statuses/sample

API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/sample

``` BaconAndEggs.TWITTER_STREAMING_API_GET_STATUSES_FIREHOSE ``` - GET statuses/firehose

API docs here: https://dev.twitter.com/docs/api/1.1/get/statuses/firehose
NOTE: This endpoint requires special permission to access.

``` BaconAndEggs.TWITTER_STREAMING_API_POST_STATUSES_FILTER ``` - POST statuses/filter

API docs here: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
NOTE: At least one predicate parameter (follow, locations, or track) must be specified in the POST body.


## Examples
Examples are included in the examples folder.

The examples can be ran via the following (replace <example.coffee> with the name of the example to run).

```
gulp compile && coffee examples/<example.coffee> --n
```

The examples use a few environment variables to load the Twitter API credentials. i.e.
```
creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  token_secret:  process.env.TWITTER_USER_TOKEN_SECRET
```

Prior to running the examples, either export your twitter key, secret, token, and token_secret via the command line OR
put a ``` .env ``` file at the root of the project with the values to be exported.

Example ``` .env ``` file:
```
TWITTER_USER_KEY=YOUR-USER-KEY-HERE
TWITTER_USER_SECRET=YOUR-USER-SECRET-HERE
TWITTER_USER_TOKEN=YOUR-USER-TOKEN-HERE
TWITTER_USER_TOKEN_SECRET=YOUR-USER-TOKEN-SECRET-HERE
```

## License

[MIT](http://opensource.org/licenses/MIT) © Mike Groseclose

[npm-url]: https://npmjs.org/package/bacon-and-eggs
[npm-image]: https://badge.fury.io/js/bacon-and-eggs.png

[travis-url]: http://travis-ci.org/mikegroseclose/bacon-and-eggs
[travis-image]: https://secure.travis-ci.org/mikegroseclose/bacon-and-eggs.png?branch=master
