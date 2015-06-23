
'use strict';

var util = require('util');
var msRest = require('ms-rest');
var msRestAzure = require('ms-rest-azure');
var ServiceClient = msRest.ServiceClient;
var WebResource = msRest.WebResource;

    var models = require('../models');

/**
 * @class
 * HttpSuccess
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestHeadTestService.
 * Initializes a new instance of the HttpSuccess class.
 * @constructor
 *
 * @param {AutoRestHeadTestService} client Reference to the service client.
 */
function HttpSuccess(client) {
  this.client = client;
}

    /**
     * Return 204 status code if successful
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    HttpSuccess.prototype.head204 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//http/success/204';
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'HEAD';
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
        if (statusCode !== 204 && statusCode !== 404) {
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
                error.body = client._models['CloudError'].deserialize(error.body);
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
        result.body = (statusCode === 204);

        return callback(null, result);
      });
    };

    /**
     * Return 404 status code if successful
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    HttpSuccess.prototype.head404 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//http/success/404';
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'HEAD';
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
        if (statusCode !== 204 && statusCode !== 404) {
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
                error.body = client._models['CloudError'].deserialize(error.body);
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
        result.body = (statusCode === 204);

        return callback(null, result);
      });
    };


module.exports = HttpSuccess;
