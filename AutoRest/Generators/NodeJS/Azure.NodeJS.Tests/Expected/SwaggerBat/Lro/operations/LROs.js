
'use strict';

var util = require('util');
var msRest = require('ms-rest');
var msRestAzure = require('ms-rest-azure');
var ServiceClient = msRest.ServiceClient;
var WebResource = msRest.WebResource;

    var models = require('../models');

/**
 * @class
 * LROs
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestLongRunningOperationTestService.
 * Initializes a new instance of the LROs class.
 * @constructor
 *
 * @param {AutoRestLongRunningOperationTestService} client Reference to the service client.
 */
function LROs(client) {
  this.client = client;
}

    /**
     *
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Succeeded’.
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put200Succeeded = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get200Succeeded(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut200Succeeded(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Succeeded’.
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut200Succeeded = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 200 && statusCode !== 204) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Succeeded’.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.get200Succeeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that does not contain ProvisioningState=’Succeeded’.
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put200SucceededNoState = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get200SucceededNoState(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut200SucceededNoState(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that does not contain ProvisioningState=’Succeeded’.
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut200SucceededNoState = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/succeeded/nostate';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Succeeded’.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.get200SucceededNoState = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/succeeded/nostate';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 202 to the initial request,
     * with a location header that points to a polling URL that returns a 200 and
     * an entity that doesn't contains ProvisioningState
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put202Retry200 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getPut202Retry200(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut202Retry200(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 202 to the initial request,
     * with a location header that points to a polling URL that returns a 200 and
     * an entity that doesn't contains ProvisioningState
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut202Retry200 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/202/retry/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Succeeded’.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getPut202Retry200 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/202/retry/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put201CreatingSucceeded200 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get201CreatingSucceeded200Polling(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut201CreatingSucceeded200(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut201CreatingSucceeded200 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/201/creating/succeeded/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 200 && statusCode !== 201) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError.request = httpRequest;
            deserializationError.response = response;
            return callback(deserializationError);
          }
        }
        // Deserialize Response
        if (statusCode === 201) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError1 = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError1.request = httpRequest;
            deserializationError1.response = response;
            return callback(deserializationError1);
          }
        }

        return callback(null, result);
      });
    };

    /**
     * Long running put request poller, service returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.get201CreatingSucceeded200Polling = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/201/creating/succeeded/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Updating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put200UpdatingSucceeded204 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get200CreatingSucceeded200Poll(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut200UpdatingSucceeded204(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Updating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut200UpdatingSucceeded204 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/updating/succeeded/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Polling endpoinnt for Long running put request, service returns a 200
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.get200CreatingSucceeded200Poll = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/updating/succeeded/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Created’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Failed’
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put201CreatingFailed200 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get201CreatingFailed200Polling(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut201CreatingFailed200(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Created’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Failed’
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut201CreatingFailed200 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/201/created/failed/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 200 && statusCode !== 201) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError.request = httpRequest;
            deserializationError.response = response;
            return callback(deserializationError);
          }
        }
        // Deserialize Response
        if (statusCode === 201) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError1 = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError1.request = httpRequest;
            deserializationError1.response = response;
            return callback(deserializationError1);
          }
        }

        return callback(null, result);
      });
    };

    /**
     * Long running put request poller, service returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.get201CreatingFailed200Polling = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/201/created/failed/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Canceled’
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.put200Acceptedcanceled200 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get200Acceptedcanceled200Poll(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut200Acceptedcanceled200(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 201 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Canceled’
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPut200Acceptedcanceled200 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/accepted/canceled/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Polling endpoinnt for Long running put request, service returns a 200
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.get200Acceptedcanceled200Poll = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/200/accepted/canceled/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 202 to the initial request with
     * location header. Subsequent calls to operation status do not contain
     * location header.
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putNoHeaderInRetry = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getPutNoHeaderInRetry(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutNoHeaderInRetry(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 202 to the initial request with
     * location header. Subsequent calls to operation status do not contain
     * location header.
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutNoHeaderInRetry = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/noheader/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running get request for you to retrieve create resource. This method
     * should not be invoked
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getPutNoHeaderInRetry = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/put/noheader/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncRetrySucceeded = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRetrySucceeded(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRetrySucceeded(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncRetrySucceeded = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/retry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getAsyncRetrySucceeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/retry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncNoRetrySucceeded = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncNoRetrySucceeded(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncNoRetrySucceeded(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncNoRetrySucceeded = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/noretry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getAsyncNoRetrySucceeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/noretry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncRetryFailed = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRetryFailed(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRetryFailed(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncRetryFailed = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/retry/failed';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getAsyncRetryFailed = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/retry/failed';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncNoRetrycanceled = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncNoRetrycanceled(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncNoRetrycanceled(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncNoRetrycanceled = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/noretry/canceled';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getAsyncNoRetrycanceled = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/noretry/canceled';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request, service returns a 202 to the initial request with
     * Azure-AsyncOperation header. Subsequent calls to operation status do not
     * contain Azure-AsyncOperation header.
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncNoHeaderInRetry = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getPutAsyncNoHeaderInRetry(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncNoHeaderInRetry(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 202 to the initial request with
     * Azure-AsyncOperation header. Subsequent calls to operation status do not
     * contain Azure-AsyncOperation header.
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncNoHeaderInRetry = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/noheader/201/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 201) {
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
        // Deserialize Response
        if (statusCode === 201) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     * Long running get request for you to retrieve create resource
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getPutAsyncNoHeaderInRetry = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putasync/noheader/201/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running put request with non resource.
        * @param {Sku} [sku] sku to put
        *
        * @param {String} [sku.id] 
        *
        * @param {String} [sku.name] 
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putNonResource = function (sku, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getNonResource(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutNonResource(sku, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request with non resource.
     * @param {Sku} [sku] sku to put
     *
     * @param {String} [sku.id] 
     *
     * @param {String} [sku.name] 
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutNonResource = function (sku, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (sku !== null && sku !== undefined) {
          client._models['Sku'].validate(sku);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putnonresource/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(sku));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Sku'].deserialize(result.body);
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
     * Long running get request for you to retrieve created non resource
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getNonResource = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putnonresource/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Sku'].deserialize(result.body);
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
     *
     * Long running put request with non resource.
        * @param {Sku} [sku] Sku to put
        *
        * @param {String} [sku.id] 
        *
        * @param {String} [sku.name] 
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncNonResource = function (sku, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncNonResource(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncNonResource(sku, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request with non resource.
     * @param {Sku} [sku] Sku to put
     *
     * @param {String} [sku.id] 
     *
     * @param {String} [sku.name] 
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncNonResource = function (sku, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (sku !== null && sku !== undefined) {
          client._models['Sku'].validate(sku);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putnonresourceasync/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(sku));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Sku'].deserialize(result.body);
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
     * Long running get request for you to retrieve created non resource
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getAsyncNonResource = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putnonresourceasync/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Sku'].deserialize(result.body);
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
     *
     * Long running put request with sub resource.
        * @param {SubProduct} [product] Sub Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putSubResource = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getSubResource(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutSubResource(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request with sub resource.
     * @param {SubProduct} [product] Sub Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutSubResource = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['SubProduct'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putsubresource/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['SubProduct'].deserialize(result.body);
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
     * Long running get request for you to retrieve created sub resource
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getSubResource = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putsubresource/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['SubProduct'].deserialize(result.body);
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
     *
     * Long running put request with sub resource.
        * @param {SubProduct} [product] Sub Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.putAsyncSubResource = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncSubResource(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncSubResource(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request with sub resource.
     * @param {SubProduct} [product] Sub Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPutAsyncSubResource = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['SubProduct'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putsubresourceasync/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
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
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['SubProduct'].deserialize(result.body);
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
     * Long running get request for you to retrieve created sub resource
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.getAsyncSubResource = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/putsubresourceasync/202/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['SubProduct'].deserialize(result.body);
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
     *
     * Long running delete request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Accepted’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteProvisioning202Accepted200Succeeded = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteProvisioning202Accepted200Succeeded(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Accepted’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteProvisioning202Accepted200Succeeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/provisioning/202/accepted/200/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 200 && statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError.request = httpRequest;
            deserializationError.response = response;
            return callback(deserializationError);
          }
        }
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError1 = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError1.request = httpRequest;
            deserializationError1.response = response;
            return callback(deserializationError1);
          }
        }

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Failed’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteProvisioning202DeletingFailed200 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteProvisioning202DeletingFailed200(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Failed’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteProvisioning202DeletingFailed200 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/provisioning/202/deleting/200/failed';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 200 && statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError.request = httpRequest;
            deserializationError.response = response;
            return callback(deserializationError);
          }
        }
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError1 = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError1.request = httpRequest;
            deserializationError1.response = response;
            return callback(deserializationError1);
          }
        }

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Canceled’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteProvisioning202Deletingcanceled200 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteProvisioning202Deletingcanceled200(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’.  Polls return
     * this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Canceled’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteProvisioning202Deletingcanceled200 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/provisioning/202/deleting/200/canceled';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 200 && statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError.request = httpRequest;
            deserializationError.response = response;
            return callback(deserializationError);
          }
        }
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError1 = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError1.request = httpRequest;
            deserializationError1.response = response;
            return callback(deserializationError1);
          }
        }

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete succeeds and returns right away
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.delete204Succeeded = function (callback) {
      var self = this.client;
      // Send request
      this.beginDelete204Succeeded(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete succeeds and returns right away
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDelete204Succeeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/204/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 204) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request.
     * Polls return this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.delete202Retry200 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDelete202Retry200(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * Polls return this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDelete202Retry200 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/202/retry/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 200 && statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running delete request, service returns a 202 to the initial request.
     * Polls return this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.delete202NoRetry204 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDelete202NoRetry204(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * Polls return this value until the last poll returns a ‘200’ with
     * ProvisioningState=’Succeeded’
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDelete202NoRetry204 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/202/noretry/204';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 200 && statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running delete request, service returns a location header in the
     * initial request. Subsequent calls to operation status do not contain
     * location header.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteNoHeaderInRetry = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteNoHeaderInRetry(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a location header in the
     * initial request. Subsequent calls to operation status do not contain
     * location header.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteNoHeaderInRetry = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/delete/noheader';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 204 && statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns an Azure-AsyncOperation header
     * in the initial request. Subsequent calls to operation status do not
     * contain Azure-AsyncOperation header.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteAsyncNoHeaderInRetry = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncNoHeaderInRetry(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns an Azure-AsyncOperation header
     * in the initial request. Subsequent calls to operation status do not
     * contain Azure-AsyncOperation header.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteAsyncNoHeaderInRetry = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/deleteasync/noheader/202/204';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 204 && statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteAsyncRetrySucceeded = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRetrySucceeded(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteAsyncRetrySucceeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/deleteasync/retry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteAsyncNoRetrySucceeded = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncNoRetrySucceeded(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteAsyncNoRetrySucceeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/deleteasync/noretry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteAsyncRetryFailed = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRetryFailed(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteAsyncRetryFailed = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/deleteasync/retry/failed';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.deleteAsyncRetrycanceled = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRetrycanceled(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginDeleteAsyncRetrycanceled = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/deleteasync/retry/canceled';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'DELETE';
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
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running post request, service returns a 202 to the initial request,
     * with 'Location' header. Poll returns a 200 with a response body after
     * success.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.post200WithPayload = function (callback) {
      var self = this.client;
      // Send request
      this.beginPost200WithPayload(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with 'Location' header. Poll returns a 200 with a response body after
     * success.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPost200WithPayload = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/post/payload/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
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
        if (statusCode !== 202 && statusCode !== 200) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Sku'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError.request = httpRequest;
            deserializationError.response = response;
            return callback(deserializationError);
          }
        }
        // Deserialize Response
        if (statusCode === 200) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Sku'].deserialize(result.body);
            }
          } catch (error) {
            var deserializationError1 = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
            deserializationError1.request = httpRequest;
            deserializationError1.response = response;
            return callback(deserializationError1);
          }
        }

        return callback(null, result);
      });
    };

    /**
     *
     * Long running post request, service returns a 202 to the initial request,
     * with 'Location' and 'Retry-After' headers, Polls return a 200 with a
     * response body after success
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.post202Retry200 = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPost202Retry200(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with 'Location' and 'Retry-After' headers, Polls return a 200 with a
     * response body after success
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPost202Retry200 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/post/202/retry/200';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
      httpRequest.headers = {};
      httpRequest.url = requestUrl;
      // Set Headers
      httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
      // Serialize Request
      var requestContent = null;
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running post request, service returns a 202 to the initial request,
     * with 'Location' header, 204 with noresponse body after success
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.post202NoRetry204 = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPost202NoRetry204(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with 'Location' header, 204 with noresponse body after success
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPost202NoRetry204 = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/post/202/noretry/204';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
      httpRequest.headers = {};
      httpRequest.url = requestUrl;
      // Set Headers
      httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
      // Serialize Request
      var requestContent = null;
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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
        // Deserialize Response
        if (statusCode === 202) {
          var parsedResponse;
          try {
            parsedResponse = JSON.parse(responseBody);
            result.body = parsedResponse;
            if (result.body !== null && result.body !== undefined) {
              result.body = client._models['Product'].deserialize(result.body);
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
     *
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.postAsyncRetrySucceeded = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRetrySucceeded(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPostAsyncRetrySucceeded = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/postasync/retry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
      httpRequest.headers = {};
      httpRequest.url = requestUrl;
      // Set Headers
      httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
      // Serialize Request
      var requestContent = null;
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.postAsyncNoRetrySucceeded = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncNoRetrySucceeded(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPostAsyncNoRetrySucceeded = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/postasync/noretry/succeeded';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
      httpRequest.headers = {};
      httpRequest.url = requestUrl;
      // Set Headers
      httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
      // Serialize Request
      var requestContent = null;
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.postAsyncRetryFailed = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRetryFailed(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPostAsyncRetryFailed = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/postasync/retry/failed';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
      httpRequest.headers = {};
      httpRequest.url = requestUrl;
      // Set Headers
      httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
      // Serialize Request
      var requestContent = null;
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };

    /**
     *
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.postAsyncRetrycanceled = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRetrycanceled(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. Poll the
     * endpoint indicated in the Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {String} [product.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROs.prototype.beginPostAsyncRetrycanceled = function (product, callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }
      // Validate
      try {
        if (product !== null && product !== undefined) {
          client._models['Product'].validate(product);
        }
      } catch (error) {
        return callback(error);
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/postasync/retry/canceled';
      var queryParameters = [];
      queryParameters.push('api-version=' + encodeURIComponent(this.client.apiVersion));
      if (queryParameters.length > 0) {
        requestUrl += '?' + queryParameters.join('&');
      }
      // trim all duplicate forward slashes in the url
      var regex = /([^:]\/)\/+/gi;
      requestUrl = requestUrl.replace(regex, '$1');

      // Create HTTP transport objects
      var httpRequest = new WebResource();
      httpRequest.method = 'POST';
      httpRequest.headers = {};
      httpRequest.url = requestUrl;
      // Set Headers
      httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
      // Serialize Request
      var requestContent = null;
      requestContent = JSON.stringify(msRest.serializeObject(product));
      httpRequest.body = requestContent;
      httpRequest.headers['Content-Length'] = Buffer.isBuffer(requestContent) ? requestContent.length : Buffer.byteLength(requestContent, 'UTF8');
      // Send Request
      return client.pipeline(httpRequest, function (err, response, responseBody) {
        if (err) {
          return callback(err);
        }
        var statusCode = response.statusCode;
        if (statusCode !== 202) {
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

        return callback(null, result);
      });
    };


module.exports = LROs;
