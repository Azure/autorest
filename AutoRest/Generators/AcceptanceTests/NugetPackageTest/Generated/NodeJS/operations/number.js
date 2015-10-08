
'use strict';

var util = require('util');
var msRest = require('ms-rest');
var ServiceClient = msRest.ServiceClient;
var WebResource = msRest.WebResource;

var models = require('../models');

/**
 * @class
 * Number
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestNumberTestService.
 * Initializes a new instance of the Number class.
 * @constructor
 *
 * @param {AutoRestNumberTestService} client Reference to the service client.
 */
function Number(client) {
  this.client = client;
}

/**
 * Get null Number value
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getNull = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/null';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Get invalid float Number value
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getInvalidFloat = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/invalidfloat';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Get invalid double Number value
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getInvalidDouble = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/invaliddouble';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Put big float value 3.402823e+20
 * @param {Number} numberBody 
 *
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.putBigFloat = function (numberBody, options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (numberBody === null || numberBody === undefined || typeof numberBody !== 'number') {
      throw new Error('numberBody cannot be null or undefined and it must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/float/3.402823e+20';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(numberBody));
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
 * Get big float value 3.402823e+20
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getBigFloat = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/float/3.402823e+20';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Put big double value 2.5976931e+101
 * @param {Number} numberBody 
 *
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.putBigDouble = function (numberBody, options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (numberBody === null || numberBody === undefined || typeof numberBody !== 'number') {
      throw new Error('numberBody cannot be null or undefined and it must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/double/2.5976931e+101';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(numberBody));
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
 * Get big double value 2.5976931e+101
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getBigDouble = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/double/2.5976931e+101';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Put big double value 99999999.99
 * @param {Number} numberBody 
 *
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.putBigDoublePositiveDecimal = function (numberBody, options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (numberBody === null || numberBody === undefined || typeof numberBody !== 'number') {
      throw new Error('numberBody cannot be null or undefined and it must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/double/99999999.99';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(numberBody));
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
 * Get big double value 99999999.99
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getBigDoublePositiveDecimal = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/double/99999999.99';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Put big double value -99999999.99
 * @param {Number} numberBody 
 *
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.putBigDoubleNegativeDecimal = function (numberBody, options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (numberBody === null || numberBody === undefined || typeof numberBody !== 'number') {
      throw new Error('numberBody cannot be null or undefined and it must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/double/-99999999.99';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(numberBody));
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
 * Get big double value -99999999.99
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getBigDoubleNegativeDecimal = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/big/double/-99999999.99';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Put small float value 3.402823e-20
 * @param {Number} numberBody 
 *
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.putSmallFloat = function (numberBody, options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (numberBody === null || numberBody === undefined || typeof numberBody !== 'number') {
      throw new Error('numberBody cannot be null or undefined and it must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/small/float/3.402823e-20';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(numberBody));
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
 * Get big double value 3.402823e-20
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getSmallFloat = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/small/float/3.402823e-20';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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
 * Put small double value 2.5976931e-101
 * @param {Number} numberBody 
 *
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.putSmallDouble = function (numberBody, options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  // Validate
  try {
    if (numberBody === null || numberBody === undefined || typeof numberBody !== 'number') {
      throw new Error('numberBody cannot be null or undefined and it must be of type number.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/small/double/2.5976931e-101';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'PUT';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  // Serialize Request
  var requestContent = null;
  requestContent = JSON.stringify(msRest.serializeObject(numberBody));
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
 * Get big double value 2.5976931e-101
 * @param {object} [options]
 *
 * @param {object} [options.customHeaders] headers that will be added to
 * request
 *
 * @param {function} callback
 *
 * @returns {Stream} The Response stream
 */
Number.prototype.getSmallDouble = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri + 
                   '//number/small/double/2.5976931e-101';
  // trim all duplicate forward slashes in the url
  var regex = /([^:]\/)\/+/gi;
  requestUrl = requestUrl.replace(regex, '$1');

  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if(options) {
    for(var headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
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


module.exports = Number;
