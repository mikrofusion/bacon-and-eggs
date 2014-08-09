var request,
  __slice = [].slice;

exports.toEventStream = function() {
  var args, connection, creds, first, method, params, requestObject, resource, url;
  creds = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  if (args[0].url != null) {
    first = args[0], params = args[1];
    method = first.method, url = first.url;
    requestObject = {
      method: method,
      url: url,
      params: params
    };
  } else {
    method = args[0], resource = args[1], params = args[2];
    requestObject = request(method, resource, params);
  }
  connection = connect(creds, requestObject);
  return stream(connection);
};

request = function(method, resource, params) {
  return {
    url: "https://api.twitter.com/1.1/" + resource + ".json",
    method: method,
    params: params
  };
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

var OAuth, TWITTER_OAUTH_ACCESSS, TWITTER_OAUTH_REQUEST, connect, querystring;

OAuth = require('oauth');

querystring = require('querystring');

TWITTER_OAUTH_REQUEST = 'https://twitter.com/oauth/request_token';

TWITTER_OAUTH_ACCESSS = 'https://twitter.com/oauth/access_token';

connect = function(creds, request) {
  var connection, contentType, key, method, oauth, params, secret, token, tokenSecret, url, urlParams;
  if (creds != null) {
    key = creds.key, secret = creds.secret, token = creds.token, tokenSecret = creds.tokenSecret;
  }
  if ((key == null) || (secret == null) || (token == null) || (tokenSecret == null)) {
    throw new Error("creds must include key, method, token, and tokenSecret");
  }
  oauth = new OAuth.OAuth(TWITTER_OAUTH_REQUEST, TWITTER_OAUTH_ACCESSS, key, secret, '1.0A', null, 'HMAC-SHA1');
  if (request != null) {
    url = request.url, method = request.method, params = request.params, contentType = request.contentType;
  }
  if ((url == null) || (method == null)) {
    throw new Error("request obj must include url and method");
  }
  urlParams = "";
  if (params != null) {
    urlParams = "?" + (querystring.stringify(params));
  }
  if (contentType == null) {
    contentType = 'application/json';
  }
  if (method.toLowerCase() === 'get') {
    connection = oauth.get("" + url + urlParams, token, tokenSecret, null);
  } else if (method.toLowerCase() === 'delete') {
    connection = oauth["delete"]("" + url + urlParams, token, tokenSecret, null);
  } else if (method.toLowerCase() === 'put') {
    connection = oauth.put(url, token, tokenSecret, params, contentType, null);
  } else if (method.toLowerCase() === 'post') {
    connection = oauth.post(url, token, tokenSecret, params, contentType, null);
  } else {
    throw new Error("given an invalid http method");
  }
  connection.end();
  return Bacon.fromBinder(function(sink) {
    return connection.on('response', function(response) {
      if (response.statusCode !== 200) {
        return sink(new Bacon.Error('failed with HTTP status ' + response.statusCode));
      } else {
        response.on('data', function(data) {
          return sink(data);
        });
        return response.on('end', function() {
          return sink('\r\n');
        });
      }
    });
  });
};

if (process.env.NODE_ENV === 'TEST') {
  exports.connect = connect;
}

var Bacon, CARRIAGE_RETURN, bufferToStr, containsCarriageReturn, isValidJSON, stream, stripCarriageReturn, toJSON;

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

stream = function(connection) {
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

if (process.env.NODE_ENV === 'TEST') {
  exports.stream = stream;
}
