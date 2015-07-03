
'use strict';

var util = require('util');
var msRest = require('ms-rest');
var ServiceClient = msRest.ServiceClient;
var WebResource = msRest.WebResource;

var models = require('../models');

/**
 * @class
 * Datetime
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestDateTimeTestService.
 * Initializes a new instance of the Datetime class.
 * @constructor
 *
 * @param {AutoRestDateTimeTestService} client Reference to the service client.
 */
function Datetime(client) {
  this.client = client;
}

/**
 * Get null datetime value
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getNull = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/null';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Get invalid datetime value
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getInvalid = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/invalid';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Get overflow datetime value
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getOverflow = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/overflow';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Get underflow datetime value
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getUnderflow = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/underflow';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Put max datetime value 9999-12-31T23:59:59.9999999Z
 * @param {Date} [datetimeBody] 
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.putUtcMaxDateTime = function (datetimeBody, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (datetimeBody === null || datetimeBody === undefined) {
      throw new Error('\'datetimeBody\' cannot be null');
    }
    if (datetimeBody !== null && datetimeBody !== undefined && 
        !(datetimeBody instanceof Date || 
          (typeof datetimeBody === 'string' && !isNaN(Date.parse(datetimeBody))))) {
      throw new Error('datetimeBody must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/utc';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(datetimeBody));
  httpRequest.body = requestContent;
  httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
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
 * Get max datetime value 9999-12-31t23:59:59.9999999z
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getUtcLowercaseMaxDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/utc/lowercase';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Get max datetime value 9999-12-31T23:59:59.9999999Z
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getUtcUppercaseMaxDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/utc/uppercase';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Put max datetime value with positive numoffset
 * 9999-12-31t23:59:59.9999999+14:00
 * @param {Date} [datetimeBody] 
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.putLocalPositiveOffsetMaxDateTime = function (datetimeBody, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (datetimeBody === null || datetimeBody === undefined) {
      throw new Error('\'datetimeBody\' cannot be null');
    }
    if (datetimeBody !== null && datetimeBody !== undefined && 
        !(datetimeBody instanceof Date || 
          (typeof datetimeBody === 'string' && !isNaN(Date.parse(datetimeBody))))) {
      throw new Error('datetimeBody must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/localpositiveoffset';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(datetimeBody));
  httpRequest.body = requestContent;
  httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
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
 * Get max datetime value with positive num offset
 * 9999-12-31t23:59:59.9999999+14:00
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getLocalPositiveOffsetLowercaseMaxDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/localpositiveoffset/lowercase';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Get max datetime value with positive num offset
 * 9999-12-31T23:59:59.9999999+14:00
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getLocalPositiveOffsetUppercaseMaxDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/localpositiveoffset/uppercase';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Put max datetime value with positive numoffset
 * 9999-12-31t23:59:59.9999999-14:00
 * @param {Date} [datetimeBody] 
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.putLocalNegativeOffsetMaxDateTime = function (datetimeBody, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (datetimeBody === null || datetimeBody === undefined) {
      throw new Error('\'datetimeBody\' cannot be null');
    }
    if (datetimeBody !== null && datetimeBody !== undefined && 
        !(datetimeBody instanceof Date || 
          (typeof datetimeBody === 'string' && !isNaN(Date.parse(datetimeBody))))) {
      throw new Error('datetimeBody must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/localnegativeoffset';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(datetimeBody));
  httpRequest.body = requestContent;
  httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
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
 * Get max datetime value with positive num offset
 * 9999-12-31T23:59:59.9999999-14:00
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getLocalNegativeOffsetUppercaseMaxDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/localnegativeoffset/uppercase';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Get max datetime value with positive num offset
 * 9999-12-31t23:59:59.9999999-14:00
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getLocalNegativeOffsetLowercaseMaxDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/max/localnegativeoffset/lowercase';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Put min datetime value 0001-01-01T00:00:00Z
 * @param {Date} [datetimeBody] 
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.putUtcMinDateTime = function (datetimeBody, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (datetimeBody === null || datetimeBody === undefined) {
      throw new Error('\'datetimeBody\' cannot be null');
    }
    if (datetimeBody !== null && datetimeBody !== undefined && 
        !(datetimeBody instanceof Date || 
          (typeof datetimeBody === 'string' && !isNaN(Date.parse(datetimeBody))))) {
      throw new Error('datetimeBody must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/min/utc';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(datetimeBody));
  httpRequest.body = requestContent;
  httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
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
 * Get min datetime value 0001-01-01T00:00:00Z
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getUtcMinDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/min/utc';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Put min datetime value 0001-01-01T00:00:00+14:00
 * @param {Date} [datetimeBody] 
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.putLocalPositiveOffsetMinDateTime = function (datetimeBody, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (datetimeBody === null || datetimeBody === undefined) {
      throw new Error('\'datetimeBody\' cannot be null');
    }
    if (datetimeBody !== null && datetimeBody !== undefined && 
        !(datetimeBody instanceof Date || 
          (typeof datetimeBody === 'string' && !isNaN(Date.parse(datetimeBody))))) {
      throw new Error('datetimeBody must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/min/localpositiveoffset';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(datetimeBody));
  httpRequest.body = requestContent;
  httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
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
 * Get min datetime value 0001-01-01T00:00:00+14:00
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getLocalPositiveOffsetMinDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/min/localpositiveoffset';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};

/**
 * Put min datetime value 0001-01-01T00:00:00-14:00
 * @param {Date} [datetimeBody] 
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.putLocalNegativeOffsetMinDateTime = function (datetimeBody, callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (datetimeBody === null || datetimeBody === undefined) {
      throw new Error('\'datetimeBody\' cannot be null');
    }
    if (datetimeBody !== null && datetimeBody !== undefined && 
        !(datetimeBody instanceof Date || 
          (typeof datetimeBody === 'string' && !isNaN(Date.parse(datetimeBody))))) {
      throw new Error('datetimeBody must be of type date.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/min/localnegativeoffset';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(datetimeBody));
  httpRequest.body = requestContent;
  httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
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
 * Get min datetime value 0001-01-01T00:00:00-14:00
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Datetime.prototype.getLocalNegativeOffsetMinDateTime = function (callback) {
  var client = this.client;
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//datetime/min/localnegativeoffset';
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
    // Deserialize Response
    if (statusCode === 200) {
      var parsedResponse;
      try {
        parsedResponse = JSON.parse(responseBody);
        result.body = parsedResponse;
        if (result.body !== null && result.body !== undefined) {
          result.body = new Date(result.body);
        }
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }

    return callback(null, result);
  });
};


module.exports = Datetime;
