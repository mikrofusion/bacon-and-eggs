var OAuth, TWITTER_OAUTH_ACCESSS, TWITTER_OAUTH_REQUEST;

OAuth = require('oauth');

TWITTER_OAUTH_REQUEST = 'https://twitter.com/oauth/request_token';

TWITTER_OAUTH_ACCESSS = 'https://twitter.com/oauth/access_token';

exports.TwitterConnection = function(url, key, secret, token, token_secret) {
  var connection, oauth;
  oauth = new OAuth.OAuth(TWITTER_OAUTH_REQUEST, TWITTER_OAUTH_ACCESSS, key, secret, '1.0A', null, 'HMAC-SHA1');
  connection = oauth.get(url, token, token_secret, null);
  connection.end();
  return connection;
};

var Bacon, CARRIAGE_RETURN, bufferToStr, containsCarriageReturn, isComplete, stripCarriageReturn, toJSON;

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

isComplete = function(data) {
  return data.complete === true;
};

toJSON = function(str) {
  var err, json;
  try {
    if (str.length > 0) {
      return json = JSON.parse(str);
    }
  } catch (_error) {
    err = _error;
    console.log('Failed to parse string: ' + str);
    return null;
  }
};

exports.TwitterStream = function(connection) {
  var both, complete, data, rawData;
  rawData = Bacon.fromEventTarget(connection, 'response').flatMap(function(response) {
    return Bacon.fromEventTarget(response, 'data');
  });
  complete = rawData.map(function(raw) {
    return containsCarriageReturn(bufferToStr(raw));
  });
  both = rawData.zip(complete, function(raw, complete) {
    return {
      data: stripCarriageReturn(bufferToStr(raw)),
      complete: complete
    };
  });
  data = both.scan('', function(prev, chunk) {
    if ((prev == null) || (prev.data == null) || isComplete(prev)) {
      return {
        data: chunk.data,
        complete: chunk.complete
      };
    } else {
      return {
        data: prev.data + chunk.data,
        complete: chunk.complete
      };
    }
  });
  return data.filter(isComplete).map(function(data) {
    return toJSON(data.data);
  }).filter(function(x) {
    return x != null;
  });
};
