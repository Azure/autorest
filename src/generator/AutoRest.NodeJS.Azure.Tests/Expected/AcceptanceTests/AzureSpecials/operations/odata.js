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

const msRest = require('ms-rest');
const msRestAzure = require('ms-rest-azure');
const WebResource = msRest.WebResource;

/**
 * Specify filter parameter with value '$filter=id gt 5 and name eq
 * 'foo'&$orderby=id&$top=10'
 *
 * @param {object} [options] Optional Parameters.
 *
 * @param {string} [options.filter] The filter parameter with value '$filter=id
 * gt 5 and name eq 'foo''.
 *
 * @param {number} [options.top] The top parameter with value 10.
 *
 * @param {string} [options.orderby] The orderby parameter with value id.
 *
 * @param {object} [options.customHeaders] Headers that will be added to the
 * request
 *
 * @param {function} callback - The callback.
 *
 * @returns {function} callback(err, result, request, response)
 *
 *                      {Error}  err        - The Error object if an error occurred, null otherwise.
 *
 *                      {null} [result]   - The deserialized result object if an error did not occur.
 *
 *                      {object} [request]  - The HTTP Request object if an error did not occur.
 *
 *                      {stream} [response] - The HTTP Response stream if an error did not occur.
 */
function _getWithFilter(options, callback) {
   /* jshint validthis: true */
  let client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }
  let filter = (options && options.filter !== undefined) ? options.filter : undefined;
  let top = (options && options.top !== undefined) ? options.top : undefined;
  let orderby = (options && options.orderby !== undefined) ? options.orderby : undefined;
  // Validate
  try {
    if (filter !== null && filter !== undefined && typeof filter.valueOf() !== 'string') {
      throw new Error('filter must be of type string.');
    }
    if (top !== null && top !== undefined && typeof top !== 'number') {
      throw new Error('top must be of type number.');
    }
    if (orderby !== null && orderby !== undefined && typeof orderby.valueOf() !== 'string') {
      throw new Error('orderby must be of type string.');
    }
    if (this.client.acceptLanguage !== null && this.client.acceptLanguage !== undefined && typeof this.client.acceptLanguage.valueOf() !== 'string') {
      throw new Error('this.client.acceptLanguage must be of type string.');
    }
  } catch (error) {
    return callback(error);
  }

  // Construct URL
  let baseUrl = this.client.baseUri;
  let requestUrl = baseUrl + (baseUrl.endsWith('/') ? '' : '/') + 'azurespecials/odata/filter';
  let queryParameters = [];
  if (filter !== null && filter !== undefined) {
    queryParameters.push('$filter=' + encodeURIComponent(filter));
  }
  if (top !== null && top !== undefined) {
    queryParameters.push('$top=' + encodeURIComponent(top.toString()));
  }
  if (orderby !== null && orderby !== undefined) {
    queryParameters.push('$orderby=' + encodeURIComponent(orderby));
  }
  if (queryParameters.length > 0) {
    requestUrl += '?' + queryParameters.join('&');
  }

  // Create HTTP transport objects
  let httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  // Set Headers
  if (this.client.generateClientRequestId) {
      httpRequest.headers['x-ms-client-request-id'] = msRestAzure.generateUuid();
  }
  if (this.client.acceptLanguage !== undefined && this.client.acceptLanguage !== null) {
    httpRequest.headers['accept-language'] = this.client.acceptLanguage;
  }
  if(options) {
    for(let headerName in options['customHeaders']) {
      if (options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = options['customHeaders'][headerName];
      }
    }
  }
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  // Send Request
  return client.pipeline(httpRequest, (err, response, responseBody) => {
    if (err) {
      return callback(err);
    }
    let statusCode = response.statusCode;
    if (statusCode !== 200) {
      let error = new Error(responseBody);
      error.statusCode = response.statusCode;
      error.request = msRest.stripRequest(httpRequest);
      error.response = msRest.stripResponse(response);
      if (responseBody === '') responseBody = null;
      let parsedErrorResponse;
      try {
        parsedErrorResponse = JSON.parse(responseBody);
        if (parsedErrorResponse) {
          let internalError = null;
          if (parsedErrorResponse.error) internalError = parsedErrorResponse.error;
          error.code = internalError ? internalError.code : parsedErrorResponse.code;
          error.message = internalError ? internalError.message : parsedErrorResponse.message;
        }
        if (parsedErrorResponse !== null && parsedErrorResponse !== undefined) {
          let resultMapper = new client.models['ErrorModel']().mapper();
          error.body = client.deserialize(resultMapper, parsedErrorResponse, 'error.body');
        }
      } catch (defaultError) {
        error.message = `Error "${defaultError.message}" occurred in deserializing the responseBody ` +
                         `- "${responseBody}" for the default response.`;
        return callback(error);
      }
      return callback(error);
    }
    // Create Result
    let result = null;
    if (responseBody === '') responseBody = null;

    return callback(null, result, httpRequest, response);
  });
}

/**
 * @class
 * Odata
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestAzureSpecialParametersTestClient.
 * Initializes a new instance of the Odata class.
 * @constructor
 *
 * @param {AutoRestAzureSpecialParametersTestClient} client Reference to the service client.
 */
class Odata {
  constructor(client) {
    this.client = client;
    this._getWithFilter = _getWithFilter;
  }

  /**
   * Specify filter parameter with value '$filter=id gt 5 and name eq
   * 'foo'&$orderby=id&$top=10'
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.filter] The filter parameter with value '$filter=id
   * gt 5 and name eq 'foo''.
   *
   * @param {number} [options.top] The top parameter with value 10.
   *
   * @param {string} [options.orderby] The orderby parameter with value id.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @returns {Promise} A promise is returned
   *
   * @resolve {HttpOperationResponse<null>} - The deserialized result object.
   *
   * @reject {Error} - The error object.
   */
  getWithFilterWithHttpOperationResponse(options) {
    let client = this.client;
    let self = this;
    return new Promise((resolve, reject) => {
      self._getWithFilter(options, (err, result, request, response) => {
        let httpOperationResponse = new msRest.HttpOperationResponse(request, response);
        httpOperationResponse.body = result;
        if (err) { reject(err); }
        else { resolve(httpOperationResponse); }
        return;
      });
    });
  }

  /**
   * Specify filter parameter with value '$filter=id gt 5 and name eq
   * 'foo'&$orderby=id&$top=10'
   *
   * @param {object} [options] Optional Parameters.
   *
   * @param {string} [options.filter] The filter parameter with value '$filter=id
   * gt 5 and name eq 'foo''.
   *
   * @param {number} [options.top] The top parameter with value 10.
   *
   * @param {string} [options.orderby] The orderby parameter with value id.
   *
   * @param {object} [options.customHeaders] Headers that will be added to the
   * request
   *
   * @param {function} [optionalCallback] - The optional callback.
   *
   * @returns {function|Promise} If a callback was passed as the last parameter
   * then it returns the callback else returns a Promise.
   *
   * {Promise} A promise is returned
   *
   *                      @resolve {null} - The deserialized result object.
   *
   *                      @reject {Error} - The error object.
   *
   * {function} optionalCallback(err, result, request, response)
   *
   *                      {Error}  err        - The Error object if an error occurred, null otherwise.
   *
   *                      {null} [result]   - The deserialized result object if an error did not occur.
   *
   *                      {object} [request]  - The HTTP Request object if an error did not occur.
   *
   *                      {stream} [response] - The HTTP Response stream if an error did not occur.
   */
  getWithFilter(options, optionalCallback) {
    let client = this.client;
    let self = this;
    if (!optionalCallback && typeof options === 'function') {
      optionalCallback = options;
      options = null;
    }
    if (!optionalCallback) {
      return new Promise((resolve, reject) => {
        self._getWithFilter(options, (err, result, request, response) => {
          if (err) { reject(err); }
          else { resolve(result); }
          return;
        });
      });
    } else {
      return self._getWithFilter(options, optionalCallback);
    }
  }

}

module.exports = Odata;
