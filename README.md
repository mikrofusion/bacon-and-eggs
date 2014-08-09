#bacon-and-eggs

[![NPM](https://nodei.co/npm/bacon-and-eggs.png)](https://nodei.co/npm/bacon-and-eggs/)

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url]

A functional reactive Twitter API client in node.

## Install

```bash
$ npm install bacon-and-eggs
```

## Use
The following shows how to use BaconAndEggs can be used to connect to a Twitter API stream.
In this example we connect to the statuses_filter stream and look for public tweets containing the string 'funny'.

```
creds =
  key: process.env.TWITTER_USER_KEY
  secret: process.env.TWITTER_USER_SECRET
  token:  process.env.TWITTER_USER_TOKEN
  tokenSecret:  process.env.TWITTER_USER_TOKEN_SECRET

request = BaconAndEggs.requestStatusesFilterStreaming { track: 'funny' }

stream = BaconAndEggs.toEventStream(creds, request)

stream.log()
```

## API

### toEventStream(creds, request)
####Description:
Returns a [bacon.js](http://baconjs.github.io/) EventStream containing JSON responses from the Twitter API.
See the bacon.js [documentation](https://github.com/baconjs/bacon.js/#common-methods-in-eventstreams-and-properties) for a list of methods that can be applied to a bacon.js EventStream.


####Arguments:
``` creds ``` -
An object containing the keys 'key', 'secret', 'token', 'token_secret' with values being your API key, secret, token, and token secret.
If needed, API credentials can be obtained from the [twitter app manager](https://apps.twitter.com/app/new).

``` request ``` -
A request object created from one of the following methods

### requestUserStreaming(params)
Returns a reqest object as a GET request against the twitter user [Streaming API](https://dev.twitter.com/docs/api/1.1/get/user).

``` params ``` (optional) are passed as part of the request.

### requestSiteStreaming(params) ```
Returns a reqest object as a GET request against the twitter site[Streaming API](https://dev.twitter.com/docs/api/1.1/get/site).

``` params ``` (optional) are passed as part of the request.

### requestStatusesSampleStreaming(params) ```
Returns a reqest object as a GET request against the twitter sample [Streaming API](https://dev.twitter.com/docs/api/1.1/get/statuses/sample).

``` params ``` (optional) are passed as part of the request.

### requestStatusesFirehoseStreaming(params) ```
Returns a reqest object as a GET request against the twitter firehose [Streaming API](https://dev.twitter.com/docs/api/1.1/get/statuses/firehose).

Note: This endpoint requires special permission to access.

``` params ``` (optional) are passed as part of the request.

### requestStatusesFilterStreaming(params) ```
Returns a reqest object as a POST request against the twitter filter [Streaming API](https://dev.twitter.com/docs/api/1.1/post/statuses/filter).

``` params ``` (required) are passed as part of the request.
Note: At least one param (follow, locations, or track) must be specified in the POST body.

### request(method, resource, params) ```
Returns a reqest object as a request to be performed against the Twitter [REST API](https://dev.twitter.com/docs/api/1.1).

``` method ``` (required) is the HTTP method ('get', 'put', 'post', or 'delete')
``` resource ``` (required) is the REST API resource (e.g. 'user', 'followers/ids', etc)
``` params ``` (optional) are passed as part of the request.

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
