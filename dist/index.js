var Bacon;

Bacon = require('baconjs');

exports.TwitterBus1 = function(connection) {
  return {
    push: function(data) {
      return this.onValue(data.method, data.data);
    },
    onValue: function(arg) {
      return console.log('test');
    }
  };
};

exports.TwitterBus = function(connection) {
  var bus;
  bus = new Bacon.Bus();
  bus.onValue(function(val) {});
  return bus;
};

var OAuth, TWITTER_OAUTH_ACCESSS, TWITTER_OAUTH_REQUEST;

OAuth = require('oauth');

TWITTER_OAUTH_REQUEST = 'https://twitter.com/oauth/request_token';

TWITTER_OAUTH_ACCESSS = 'https://twitter.com/oauth/access_token';

exports.TwitterConnection = function(request, creds, post_data, callback) {
  var body, connection, content_type, key, method, oauth, secret, token, token_secret, url;
  if (request) {
    url = request.url, method = request.method;
  }
  if ((url == null) || (method == null)) {
    throw new Error("TwitterConnection request obj must include url and method");
  }
  if (creds) {
    key = creds.key, secret = creds.secret, token = creds.token, token_secret = creds.token_secret;
  }
  if ((key == null) || (method == null) || (token == null) || (token_secret == null)) {
    throw new Error("TwitterConnection creds obj must include key, method," + " token, and token_secret");
  }
  if (post_data != null) {
    content_type = post_data.content_type, body = post_data.body;
  }
  if (typeof callback !== "function") {
    throw new Error("TwitterConnection requires a callback");
  }
  oauth = new OAuth.OAuth(TWITTER_OAUTH_REQUEST, TWITTER_OAUTH_ACCESSS, key, secret, '1.0A', null, 'HMAC-SHA1');
  if (method.toLowerCase() === 'get') {
    connection = oauth.get(url, token, token_secret, null);
  } else if (method.toLowerCase() === 'delete') {
    connection = oauth["delete"](url, token, token_secret, null);
  } else if (method.toLowerCase() === 'put') {
    connection = oauth.put(url, token, token_secret, body, content_type, null);
  } else if (method.toLowerCase() === 'post') {
    connection = oauth.post(url, token, token_secret, body, content_type, null);
  } else {
    throw new Error("TwitterConnection given an invalid http method");
  }
  connection.end();
  return connection.on('response', function(response) {
    var err;
    if (response.statusCode !== 200) {
      err = new Error('TwitterConnection failed with HTTP status ' + response.statusCode);
      return callback(err, null);
    } else {
      return callback(null, Bacon.fromEventTarget(response, 'data'));
    }
  });
};

exports.TWITTER_STREAMING_API_GET_USER = {
  url: 'https://userstream.twitter.com/1.1/user.json',
  method: 'get'
};

exports.TWITTER_STREAMING_API_GET_SITE = {
  url: 'https://sitestream.twitter.com/1.1/site.json',
  method: 'get'
};

exports.TWITTER_STREAMING_API_GET_STATUSES_SAMPLE = {
  url: 'https://stream.twitter.com/1.1/statuses/sample.json',
  method: 'get'
};

exports.TWITTER_STREAMING_API_GET_STATUSES_FIREHOSE = {
  url: 'https://stream.twitter.com/1.1/statuses/firehose.json',
  method: 'get'
};

exports.TWITTER_STREAMING_API_POST_STATUSES_FILTER = {
  url: 'https://stream.twitter.com/1.1/statuses/filter.json',
  method: 'post'
};

var Bacon, CARRIAGE_RETURN, bufferToStr, containsCarriageReturn, isValidJSON, stripCarriageReturn, toJSON;

Bacon = require('baconjs');

CARRIAGE_RETURN = '\r\n';

containsCarriageReturn = function(str) {
  return str.indexOf(CARRIAGE_RETURN) > -1;
};

stripCarriageReturn = function(str) {
  if (containsCarriageReturn(str)) {
    return str.slice(0, str.indexOf(CARRIAGE_RETURN));
  } else {
    return str;
  }
};

bufferToStr = function(buf) {
  return buf + '';
};

isValidJSON = function(str) {
  var err;
  try {
    JSON.parse(str);
    return true;
  } catch (_error) {
    err = _error;
    return false;
  }
};

toJSON = function(str) {
  if (isValidJSON(str)) {
    return JSON.parse(str);
  } else {
    return null;
  }
};

exports.TwitterStream = function(connection) {
  var isCompleteStream;
  isCompleteStream = connection.map(function(data) {
    return containsCarriageReturn(bufferToStr(data));
  });
  return connection.zip(isCompleteStream, function(data, isComplete) {
    return {
      data: stripCarriageReturn(bufferToStr(data)),
      isComplete: isComplete
    };
  }).scan('', function(prev, chunk) {
    if ((prev == null) || (prev.data == null) || prev.isComplete === true) {
      return {
        data: chunk.data,
        isComplete: chunk.isComplete
      };
    } else {
      return {
        data: prev.data + chunk.data,
        isComplete: chunk.isComplete
      };
    }
  }).filter(function(data) {
    return isValidJSON(data.data) && data.isComplete === true;
  }).map(function(data) {
    return toJSON(data.data);
  });
};
