
'use strict';

var util = require('util');
var msRest = require('ms-rest');
var ServiceClient = msRest.ServiceClient;
var WebResource = msRest.WebResource;

var models = require('../models');

/**
 * @class
 * Queries
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestUrlTestService.
 * Initializes a new instance of the Queries class.
 * @constructor
 *
 * @param {AutoRestUrlTestService} client Reference to the service client.
 */
function Queries(client) {
  this.client = client;
}

/**
 * Get true Boolean value on path
 * @param {Boolean} [boolQuery] true boolean value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getBooleanTrue = function (boolQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (boolQuery !== null && boolQuery !== undefined && typeof boolQuery !== 'boolean') {
      throw new Error('boolQuery must be of type boolean.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/bool/true';
  var queryParameters = [];
  if (boolQuery !== null && boolQuery !== undefined) {
    queryParameters.push('boolQuery=' + encodeURIComponent(boolQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get false Boolean value on path
 * @param {Boolean} [boolQuery] false boolean value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getBooleanFalse = function (boolQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (boolQuery !== null && boolQuery !== undefined && typeof boolQuery !== 'boolean') {
      throw new Error('boolQuery must be of type boolean.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/bool/false';
  var queryParameters = [];
  if (boolQuery !== null && boolQuery !== undefined) {
    queryParameters.push('boolQuery=' + encodeURIComponent(boolQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null Boolean value on query (query string should be absent)
 * @param {Boolean} [boolQuery] null boolean value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getBooleanNull = function (boolQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (boolQuery !== null && boolQuery !== undefined && typeof boolQuery !== 'boolean') {
      throw new Error('boolQuery must be of type boolean.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/bool/null';
  var queryParameters = [];
  if (boolQuery !== null && boolQuery !== undefined) {
    queryParameters.push('boolQuery=' + encodeURIComponent(boolQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '1000000' integer value
 * @param {Number} [intQuery] '1000000' integer value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getIntOneMillion = function (intQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (intQuery !== null && intQuery !== undefined && typeof intQuery !== 'number') {
      throw new Error('intQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/int/1000000';
  var queryParameters = [];
  if (intQuery !== null && intQuery !== undefined) {
    queryParameters.push('intQuery=' + encodeURIComponent(intQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '-1000000' integer value
 * @param {Number} [intQuery] '-1000000' integer value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getIntNegativeOneMillion = function (intQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (intQuery !== null && intQuery !== undefined && typeof intQuery !== 'number') {
      throw new Error('intQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/int/-1000000';
  var queryParameters = [];
  if (intQuery !== null && intQuery !== undefined) {
    queryParameters.push('intQuery=' + encodeURIComponent(intQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null integer value (no query parameter)
 * @param {Number} [intQuery] null integer value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getIntNull = function (intQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (intQuery !== null && intQuery !== undefined && typeof intQuery !== 'number') {
      throw new Error('intQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/int/null';
  var queryParameters = [];
  if (intQuery !== null && intQuery !== undefined) {
    queryParameters.push('intQuery=' + encodeURIComponent(intQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '10000000000' 64 bit integer value
 * @param {Number} [longQuery] '10000000000' 64 bit integer value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getTenBillion = function (longQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (longQuery !== null && longQuery !== undefined && typeof longQuery !== 'number') {
      throw new Error('longQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/long/10000000000';
  var queryParameters = [];
  if (longQuery !== null && longQuery !== undefined) {
    queryParameters.push('longQuery=' + encodeURIComponent(longQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '-10000000000' 64 bit integer value
 * @param {Number} [longQuery] '-10000000000' 64 bit integer value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getNegativeTenBillion = function (longQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (longQuery !== null && longQuery !== undefined && typeof longQuery !== 'number') {
      throw new Error('longQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/long/-10000000000';
  var queryParameters = [];
  if (longQuery !== null && longQuery !== undefined) {
    queryParameters.push('longQuery=' + encodeURIComponent(longQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get 'null 64 bit integer value (no query param in uri)
 * @param {Number} [longQuery] null 64 bit integer value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.getLongNull = function (longQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (longQuery !== null && longQuery !== undefined && typeof longQuery !== 'number') {
      throw new Error('longQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/long/null';
  var queryParameters = [];
  if (longQuery !== null && longQuery !== undefined) {
    queryParameters.push('longQuery=' + encodeURIComponent(longQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '1.034E+20' numeric value
 * @param {Number} [floatQuery] '1.034E+20'numeric value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.floatScientificPositive = function (floatQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (floatQuery !== null && floatQuery !== undefined && typeof floatQuery !== 'number') {
      throw new Error('floatQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/float/1.034E+20';
  var queryParameters = [];
  if (floatQuery !== null && floatQuery !== undefined) {
    queryParameters.push('floatQuery=' + encodeURIComponent(floatQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '-1.034E-20' numeric value
 * @param {Number} [floatQuery] '-1.034E-20'numeric value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.floatScientificNegative = function (floatQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (floatQuery !== null && floatQuery !== undefined && typeof floatQuery !== 'number') {
      throw new Error('floatQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/float/-1.034E-20';
  var queryParameters = [];
  if (floatQuery !== null && floatQuery !== undefined) {
    queryParameters.push('floatQuery=' + encodeURIComponent(floatQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null numeric value (no query parameter)
 * @param {Number} [floatQuery] null numeric value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.floatNull = function (floatQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (floatQuery !== null && floatQuery !== undefined && typeof floatQuery !== 'number') {
      throw new Error('floatQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/float/null';
  var queryParameters = [];
  if (floatQuery !== null && floatQuery !== undefined) {
    queryParameters.push('floatQuery=' + encodeURIComponent(floatQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '9999999.999' numeric value
 * @param {Number} [doubleQuery] '9999999.999'numeric value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.doubleDecimalPositive = function (doubleQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (doubleQuery !== null && doubleQuery !== undefined && typeof doubleQuery !== 'number') {
      throw new Error('doubleQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/double/9999999.999';
  var queryParameters = [];
  if (doubleQuery !== null && doubleQuery !== undefined) {
    queryParameters.push('doubleQuery=' + encodeURIComponent(doubleQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '-9999999.999' numeric value
 * @param {Number} [doubleQuery] '-9999999.999'numeric value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.doubleDecimalNegative = function (doubleQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (doubleQuery !== null && doubleQuery !== undefined && typeof doubleQuery !== 'number') {
      throw new Error('doubleQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/double/-9999999.999';
  var queryParameters = [];
  if (doubleQuery !== null && doubleQuery !== undefined) {
    queryParameters.push('doubleQuery=' + encodeURIComponent(doubleQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null numeric value (no query parameter)
 * @param {Number} [doubleQuery] null numeric value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.doubleNull = function (doubleQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (doubleQuery !== null && doubleQuery !== undefined && typeof doubleQuery !== 'number') {
      throw new Error('doubleQuery must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/double/null';
  var queryParameters = [];
  if (doubleQuery !== null && doubleQuery !== undefined) {
    queryParameters.push('doubleQuery=' + encodeURIComponent(doubleQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '啊齄丂狛狜隣郎隣兀﨩' multi-byte string value
 * @param {String} [stringQuery] '啊齄丂狛狜隣郎隣兀﨩'multi-byte string value. Possible values for this parameter include: '啊齄丂狛狜隣郎隣兀﨩'
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.stringUnicode = function (stringQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (stringQuery !== null && stringQuery !== undefined && typeof stringQuery !== 'string') {
      throw new Error('stringQuery must be of type string.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/string/unicode/';
  var queryParameters = [];
  if (stringQuery !== null && stringQuery !== undefined) {
    queryParameters.push('stringQuery=' + encodeURIComponent(stringQuery));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get 'begin!*'();:@ &=+$,/?#[]end
 * @param {String} [stringQuery] 'begin!*'();:@ &=+$,/?#[]end' url encoded string value. Possible values for this parameter include: 'begin!*'();:@ &=+$,/?#[]end'
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.stringUrlEncoded = function (stringQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (stringQuery !== null && stringQuery !== undefined && typeof stringQuery !== 'string') {
      throw new Error('stringQuery must be of type string.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/string/begin%21%2A%27%28%29%3B%3A%40%20%26%3D%2B%24%2C%2F%3F%23%5B%5Dend';
  var queryParameters = [];
  if (stringQuery !== null && stringQuery !== undefined) {
    queryParameters.push('stringQuery=' + encodeURIComponent(stringQuery));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get ''
 * @param {String} [stringQuery] '' string value. Possible values for this parameter include: ''
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.stringEmpty = function (stringQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (stringQuery !== null && stringQuery !== undefined && typeof stringQuery !== 'string') {
      throw new Error('stringQuery must be of type string.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/string/empty';
  var queryParameters = [];
  if (stringQuery !== null && stringQuery !== undefined) {
    queryParameters.push('stringQuery=' + encodeURIComponent(stringQuery));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null (no query parameter in url)
 * @param {String} [stringQuery] null string value
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.stringNull = function (stringQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (stringQuery !== null && stringQuery !== undefined && typeof stringQuery !== 'string') {
      throw new Error('stringQuery must be of type string.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/string/null';
  var queryParameters = [];
  if (stringQuery !== null && stringQuery !== undefined) {
    queryParameters.push('stringQuery=' + encodeURIComponent(stringQuery));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get using uri with query parameter 'green color'
 * @param {UriColor} [enumQuery] 'green color' enum value. Possible values for this parameter include: 'red color', 'green color', 'blue color'
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.enumValid = function (enumQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (enumQuery !== null && enumQuery !== undefined) {
      var allowedValues = [ 'red color', 'green color', 'blue color' ];
      if (!allowedValues.some( function(item) { return item === enumQuery; })) {
        throw new Error(enumQuery + ' is not a valid value. The valid values are: ' + allowedValues);
      }
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/enum/green%20color';
  var queryParameters = [];
  if (enumQuery !== null && enumQuery !== undefined) {
    queryParameters.push('enumQuery=' + encodeURIComponent(enumQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null (no query parameter in url)
 * @param {UriColor} [enumQuery] null string value. Possible values for this parameter include: 'red color', 'green color', 'blue color'
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.enumNull = function (enumQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (enumQuery !== null && enumQuery !== undefined) {
      var allowedValues = [ 'red color', 'green color', 'blue color' ];
      if (!allowedValues.some( function(item) { return item === enumQuery; })) {
        throw new Error(enumQuery + ' is not a valid value. The valid values are: ' + allowedValues);
      }
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/enum/null';
  var queryParameters = [];
  if (enumQuery !== null && enumQuery !== undefined) {
    queryParameters.push('enumQuery=' + encodeURIComponent(enumQuery.toString()));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
 * @param {Buffer} [byteQuery] '啊齄丂狛狜隣郎隣兀﨩' multibyte value as utf-8 encoded byte array
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.byteMultiByte = function (byteQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (byteQuery !== null && byteQuery !== undefined && !Buffer.isBuffer(byteQuery)) {
      throw new Error('byteQuery must be of type buffer.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/byte/multibyte';
  var queryParameters = [];
  if (byteQuery !== null && byteQuery !== undefined) {
    queryParameters.push('byteQuery=' + encodeURIComponent(msRest.serializeObject(byteQuery)));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '' as byte array
 * @param {Buffer} [byteQuery] '' as byte array
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.byteEmpty = function (byteQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (byteQuery !== null && byteQuery !== undefined && !Buffer.isBuffer(byteQuery)) {
      throw new Error('byteQuery must be of type buffer.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/byte/empty';
  var queryParameters = [];
  if (byteQuery !== null && byteQuery !== undefined) {
    queryParameters.push('byteQuery=' + encodeURIComponent(msRest.serializeObject(byteQuery)));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null as byte array (no query parameters in uri)
 * @param {Buffer} [byteQuery] null as byte array (no query parameters in uri)
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.byteNull = function (byteQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (byteQuery !== null && byteQuery !== undefined && !Buffer.isBuffer(byteQuery)) {
      throw new Error('byteQuery must be of type buffer.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/byte/null';
  var queryParameters = [];
  if (byteQuery !== null && byteQuery !== undefined) {
    queryParameters.push('byteQuery=' + encodeURIComponent(msRest.serializeObject(byteQuery)));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '2012-01-01' as date
 * @param {Date} [dateQuery] '2012-01-01' as date
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.dateValid = function (dateQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (dateQuery !== null && dateQuery !== undefined && 
        !(dateQuery instanceof Date || 
          (typeof dateQuery === 'string' && !isNaN(Date.parse(dateQuery))))) {
      throw new Error('dateQuery must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/date/2012-01-01';
  var queryParameters = [];
  if (dateQuery !== null && dateQuery !== undefined) {
    queryParameters.push('dateQuery=' + encodeURIComponent(msRest.serializeObject(dateQuery).replace(/[Tt].*[Zz]/, '')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null as date - this should result in no query parameters in uri
 * @param {Date} [dateQuery] null as date (no query parameters in uri)
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.dateNull = function (dateQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (dateQuery !== null && dateQuery !== undefined && 
        !(dateQuery instanceof Date || 
          (typeof dateQuery === 'string' && !isNaN(Date.parse(dateQuery))))) {
      throw new Error('dateQuery must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/date/null';
  var queryParameters = [];
  if (dateQuery !== null && dateQuery !== undefined) {
    queryParameters.push('dateQuery=' + encodeURIComponent(msRest.serializeObject(dateQuery).replace(/[Tt].*[Zz]/, '')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get '2012-01-01T01:01:01Z' as date-time
 * @param {Date} [dateTimeQuery] '2012-01-01T01:01:01Z' as date-time
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.dateTimeValid = function (dateTimeQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (dateTimeQuery !== null && dateTimeQuery !== undefined && 
        !(dateTimeQuery instanceof Date || 
          (typeof dateTimeQuery === 'string' && !isNaN(Date.parse(dateTimeQuery))))) {
      throw new Error('dateTimeQuery must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/datetime/2012-01-01T01%3A01%3A01Z';
  var queryParameters = [];
  if (dateTimeQuery !== null && dateTimeQuery !== undefined) {
    queryParameters.push('dateTimeQuery=' + encodeURIComponent(msRest.serializeObject(dateTimeQuery)));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get null as date-time, should result in no query parameters in uri
 * @param {Date} [dateTimeQuery] null as date-time (no query parameters)
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.dateTimeNull = function (dateTimeQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (dateTimeQuery !== null && dateTimeQuery !== undefined && 
        !(dateTimeQuery instanceof Date || 
          (typeof dateTimeQuery === 'string' && !isNaN(Date.parse(dateTimeQuery))))) {
      throw new Error('dateTimeQuery must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/datetime/null';
  var queryParameters = [];
  if (dateTimeQuery !== null && dateTimeQuery !== undefined) {
    queryParameters.push('dateTimeQuery=' + encodeURIComponent(msRest.serializeObject(dateTimeQuery)));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' ,
 * null, ''] using the csv-array format
 * @param {Array} [arrayQuery] an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, ''] using the csv-array format
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.arrayStringCsvValid = function (arrayQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (arrayQuery !== null && arrayQuery !== undefined && util.isArray(arrayQuery)) {
      arrayQuery.forEach(function(element) {
        if (element !== null && element !== undefined && typeof element !== 'string') {
          throw new Error('element must be of type string.');
        }
      });
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/array/csv/string/valid';
  var queryParameters = [];
  if (arrayQuery !== null && arrayQuery !== undefined) {
    queryParameters.push('arrayQuery=' + encodeURIComponent(arrayQuery.join(',')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get a null array of string using the csv-array format
 * @param {Array} [arrayQuery] a null array of string using the csv-array format
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.arrayStringCsvNull = function (arrayQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (arrayQuery !== null && arrayQuery !== undefined && util.isArray(arrayQuery)) {
      arrayQuery.forEach(function(element) {
        if (element !== null && element !== undefined && typeof element !== 'string') {
          throw new Error('element must be of type string.');
        }
      });
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/array/csv/string/null';
  var queryParameters = [];
  if (arrayQuery !== null && arrayQuery !== undefined) {
    queryParameters.push('arrayQuery=' + encodeURIComponent(arrayQuery.join(',')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get an empty array [] of string using the csv-array format
 * @param {Array} [arrayQuery] an empty array [] of string using the csv-array format
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.arrayStringCsvEmpty = function (arrayQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (arrayQuery !== null && arrayQuery !== undefined && util.isArray(arrayQuery)) {
      arrayQuery.forEach(function(element) {
        if (element !== null && element !== undefined && typeof element !== 'string') {
          throw new Error('element must be of type string.');
        }
      });
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/array/csv/string/empty';
  var queryParameters = [];
  if (arrayQuery !== null && arrayQuery !== undefined) {
    queryParameters.push('arrayQuery=' + encodeURIComponent(arrayQuery.join(',')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' ,
 * null, ''] using the ssv-array format
 * @param {Array} [arrayQuery] an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, ''] using the ssv-array format
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.arrayStringSsvValid = function (arrayQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (arrayQuery !== null && arrayQuery !== undefined && util.isArray(arrayQuery)) {
      arrayQuery.forEach(function(element) {
        if (element !== null && element !== undefined && typeof element !== 'string') {
          throw new Error('element must be of type string.');
        }
      });
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/array/ssv/string/valid';
  var queryParameters = [];
  if (arrayQuery !== null && arrayQuery !== undefined) {
    queryParameters.push('arrayQuery=' + encodeURIComponent(arrayQuery.join(' ')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' ,
 * null, ''] using the tsv-array format
 * @param {Array} [arrayQuery] an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, ''] using the tsv-array format
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.arrayStringTsvValid = function (arrayQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (arrayQuery !== null && arrayQuery !== undefined && util.isArray(arrayQuery)) {
      arrayQuery.forEach(function(element) {
        if (element !== null && element !== undefined && typeof element !== 'string') {
          throw new Error('element must be of type string.');
        }
      });
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/array/tsv/string/valid';
  var queryParameters = [];
  if (arrayQuery !== null && arrayQuery !== undefined) {
    queryParameters.push('arrayQuery=' + encodeURIComponent(arrayQuery.join('	')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};

/**
 * Get an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' ,
 * null, ''] using the pipes-array format
 * @param {Array} [arrayQuery] an array of string ['ArrayQuery1', 'begin!*'();:@ &=+$,/?#[]end' , null, ''] using the pipes-array format
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Queries.prototype.arrayStringPipesValid = function (arrayQuery, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (arrayQuery !== null && arrayQuery !== undefined && util.isArray(arrayQuery)) {
      arrayQuery.forEach(function(element) {
        if (element !== null && element !== undefined && typeof element !== 'string') {
          throw new Error('element must be of type string.');
        }
      });
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//queries/array/pipes/string/valid';
  var queryParameters = [];
  if (arrayQuery !== null && arrayQuery !== undefined) {
    queryParameters.push('arrayQuery=' + encodeURIComponent(arrayQuery.join('|')));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = httpRequest;
      error.response = response;
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        error.body = parsedErrorResponse;
          if (error.body !== null && error.body !== undefined) {
            error.body = client._models['ErrorModel'].deserialize(error.body);
          }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody - "%s" for the default response.', defaultError, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;

    return callback(null, result);
  });
};


module.exports = Queries;
