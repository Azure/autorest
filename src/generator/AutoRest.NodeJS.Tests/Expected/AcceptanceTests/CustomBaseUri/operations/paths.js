/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 * 
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

'use strict';

var util = require('util');
var msRest = require('ms-rest');
var WebResource = msRest.WebResource;

/**
 * @class
 * Paths
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestParameterizedHostTestClient.
 * Initializes a new instance of the Paths class.
 * @constructor
 *
 * @param {AutoRestParameterizedHostTestClient} client Reference to the service client.
 */
function Paths(client) {
  this.client = client;
}

/**
 * Get a 200 to test a valid base uri
 *
 * @param {string} accountName Account Name
 * 
 * @param {object} [options] Optional Parameters.
 * 
 * @param {object} [options.customHeaders] Headers that will be added to the
 * request
 * 
 * @param {function} callback
 *
 * @returns {function} callback(err, result, request, response)
 *
 *                      {Error}  err        - The Error object if an error occurred, null otherwise.
 *
 *                      {null} [result]   - The deserialized result object.
 *
 *                      {object} [request]  - The HTTP Request object if an error did not occur.
 *
 *                      {stream} [response] - The HTTP Response stream if an error did not occur.
 */
Paths.prototype.getEmpty = function (accountName, options, callback) {
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
    if (accountName === null || accountName === undefined || typeof accountName.valueOf() !== 'string') {
      throw new Error('accountName cannot be null or undefined and it must be of type string.');
    }
    if (this.client.host === null || this.client.host === undefined || typeof this.client.host.valueOf() !== 'string') {
      throw new Error('this.client.host cannot be null or undefined and it must be of type string.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  var baseUrl = this.client.baseUri;
  var requestUrl = baseUrl + (baseUrl.endsWith('/') ? '' : '/') + 'customuri';
  requestUrl = requestUrl.replace('{accountName}', accountName);
  requestUrl = requestUrl.replace('{host}', this.client.host);

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
  // Send Request
  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200) {
      var error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = msRest.stripRequest(httpRequest);
      error.response = msRest.stripResponse(response);
      if (responseBody === '') responseBody = null;
      var parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        if (parsedErrorResponse) {
          var internalError = null;
          if (parsedErrorResponse.error) internalError = parsedErrorResponse.error;
          if (parsedErrorResponse.code) error.code = internalError ? internalError.code : parsedErrorResponse.code;
          if (parsedErrorResponse.message) error.message = internalError ? internalError.message : parsedErrorResponse.message;
        }
        if (parsedErrorResponse !== null && parsedErrorResponse !== undefined) {
          var resultMapper = new client.models['ErrorModel']().mapper();
          error.body = client.deserialize(resultMapper, parsedErrorResponse, 'error.body');
        }
      } catch (defaultError) {
        error.message = util.format('Error "%s" occurred in deserializing the responseBody ' + 
                         '- "%s" for the default response.', defaultError.message, responseBody);
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    var result = null;
    if (responseBody === '') responseBody = null;

    return callback(null, result, httpRequest, response);
  });
};


module.exports = Paths;
