
'use strict';

var util = require('util');
var msRest = require('ms-rest');
var msRestAzure = require('ms-rest-azure');
var ServiceClient = msRest.ServiceClient;
var WebResource = msRest.WebResource;

    var models = require('../models');

/**
 * @class
 * LROSADs
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestLongRunningOperationTestService.
 * Initializes a new instance of the LROSADs class.
 * @constructor
 *
 * @param {AutoRestLongRunningOperationTestService} client Reference to the service client.
 */
function LROSADs(client) {
  this.client = client;
}

    /**
     *
     * Long running put request, service returns a 400 to the initial request
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putNonRetry400 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getNonRetry400(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutNonRetry400(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 400 to the initial request
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutNonRetry400 = function (product, callback) {
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
                       '//lro/nonretryerror/put/400';
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
     * DO NOT CALL THIS METHOD. For completion only
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.getNonRetry400 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/nonretryerror/put/400';
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
     * Long running put request, service returns a Product with
     * 'ProvisioningState' = 'Creating' and 201 response code
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putNonRetry201Creating400 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getNonRetry201Creating400(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutNonRetry201Creating400(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a Product with
     * 'ProvisioningState' = 'Creating' and 201 response code
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutNonRetry201Creating400 = function (product, callback) {
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
                       '//lro/nonretryerror/put/201/creating/400';
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
     * Long running opeartion polling returns a 400 with no error body
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.getNonRetry201Creating400 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/nonretryerror/put/201/creating/400';
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
     * Long running put request, service returns a 200 with
     * ProvisioningState=’Creating’. Poll the endpoint indicated in the
     * Azure-AsyncOperation header for operation status
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putAsyncRelativeRetry400 = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRelativeRetry400(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRelativeRetry400(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 with
     * ProvisioningState=’Creating’. Poll the endpoint indicated in the
     * Azure-AsyncOperation header for operation status
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutAsyncRelativeRetry400 = function (product, callback) {
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
                       '//lro/nonretryerror/putasync/retry/400';
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
     * DO NOT CALL THIS METHOD. For completion only
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.getAsyncRelativeRetry400 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/nonretryerror/putasync/retry/400';
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
     * Long running delete request, service returns a 400 with an error body
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.deleteNonRetry400 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteNonRetry400(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 400 with an error body
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginDeleteNonRetry400 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/nonretryerror/delete/400';
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
     * Long running delete request, service returns a 202 with a location header
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.delete202NonRetry400 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDelete202NonRetry400(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 with a location header
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginDelete202NonRetry400 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/nonretryerror/delete/202/retry/400';
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
    LROSADs.prototype.deleteAsyncRelativeRetry400 = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRelativeRetry400(function (err, result){
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
    LROSADs.prototype.beginDeleteAsyncRelativeRetry400 = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/nonretryerror/deleteasync/retry/400';
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
     * Long running post request, service returns a 400 with no error body
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.postNonRetry400 = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostNonRetry400(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 400 with no error body
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPostNonRetry400 = function (product, callback) {
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
                       '//lro/nonretryerror/post/400';
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
     * Long running post request, service returns a 202 with a location header
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.post202NonRetry400 = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPost202NonRetry400(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 with a location header
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPost202NonRetry400 = function (product, callback) {
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
                       '//lro/nonretryerror/post/202/retry/400';
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
     * Long running post request, service returns a 202 to the initial request
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.postAsyncRelativeRetry400 = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRelativeRetry400(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPostAsyncRelativeRetry400 = function (product, callback) {
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
                       '//lro/nonretryerror/postasync/retry/400';
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
     * Long running put request, service returns a 201 to the initial request with
     * no payload
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putError201NoProvisioningStatePayload = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getError201NoProvisioningStatePayload(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutError201NoProvisioningStatePayload(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 201 to the initial request with
     * no payload
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutError201NoProvisioningStatePayload = function (product, callback) {
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
                       '//lro/error/put/201/noprovisioningstatepayload';
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
     * DO NOT CALL THIS METHOD. For completion only
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.getError201NoProvisioningStatePayload = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/put/201/noprovisioningstatepayload';
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
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putAsyncRelativeRetryNoStatus = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRelativeRetryNoStatus(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRelativeRetryNoStatus(product, function (err, result){
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
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutAsyncRelativeRetryNoStatus = function (product, callback) {
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
                       '//lro/error/putasync/retry/nostatus';
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
    LROSADs.prototype.getAsyncRelativeRetryNoStatus = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/putasync/retry/nostatus';
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
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putAsyncRelativeRetryNoStatusPayload = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRelativeRetryNoStatusPayload(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRelativeRetryNoStatusPayload(product, function (err, result){
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
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutAsyncRelativeRetryNoStatusPayload = function (product, callback) {
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
                       '//lro/error/putasync/retry/nostatuspayload';
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
    LROSADs.prototype.getAsyncRelativeRetryNoStatusPayload = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/putasync/retry/nostatuspayload';
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
     * Long running delete request, service returns a 204 to the initial request,
     * indicating success.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.delete204Succeeded = function (callback) {
      var self = this.client;
      // Send request
      this.beginDelete204Succeeded(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 204 to the initial request,
     * indicating success.
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginDelete204Succeeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/delete/204/nolocation';
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
     * Poll the endpoint indicated in the Azure-AsyncOperation header for
     * operation status
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.deleteAsyncRelativeRetryNoStatus = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRelativeRetryNoStatus(function (err, result){
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
    LROSADs.prototype.beginDeleteAsyncRelativeRetryNoStatus = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/deleteasync/retry/nostatus';
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
     * without a location header.
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.post202NoLocation = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPost202NoLocation(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * without a location header.
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPost202NoLocation = function (product, callback) {
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
                       '//lro/error/post/202/nolocation';
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
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.postAsyncRelativeRetryNoPayload = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRelativeRetryNoPayload(product, function (err, result){
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
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPostAsyncRelativeRetryNoPayload = function (product, callback) {
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
                       '//lro/error/postasync/retry/nopayload';
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
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that is not a valid json
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.put200InvalidJson = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.get200Succeeded(callback);
        }
        return cb;
      };
      // Send request
      self.beginPut200InvalidJson(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that is not a valid json
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPut200InvalidJson = function (product, callback) {
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
                       '//lro/error/put/200/invalidjson';
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
     * SHOUD NOT BE CALLED
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.get200Succeeded = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/put/200/invalidjson';
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
     * with an entity that contains ProvisioningState=’Creating’. The endpoint
     * indicated in the Azure-AsyncOperation header is invalid.
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putAsyncRelativeRetryInvalidHeader = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRelativeRetryInvalidHeader(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRelativeRetryInvalidHeader(product, function (err, result){
        if (err) return callback(err);
        client.getPutOperationResult(result, getMethod(), callback);
      });
    }

    /**
     * Long running put request, service returns a 200 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. The endpoint
     * indicated in the Azure-AsyncOperation header is invalid.
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutAsyncRelativeRetryInvalidHeader = function (product, callback) {
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
                       '//lro/error/putasync/retry/invalidheader';
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
     * SHOULD NOT BE CALLED
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.getAsyncRelativeRetryInvalidHeader = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/putasync/retry/invalidheader';
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
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.putAsyncRelativeRetryInvalidJsonPolling = function (product, callback) {
      var client = this.client;
      var self = this;
      function getMethod() {
        var cb = function (callback) {
          return self.getAsyncRelativeRetryInvalidJsonPolling(callback);
        }
        return cb;
      };
      // Send request
      self.beginPutAsyncRelativeRetryInvalidJsonPolling(product, function (err, result){
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
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPutAsyncRelativeRetryInvalidJsonPolling = function (product, callback) {
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
                       '//lro/error/putasync/retry/invalidjsonpolling';
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
    LROSADs.prototype.getAsyncRelativeRetryInvalidJsonPolling = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/putasync/retry/invalidjsonpolling';
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
     * Long running delete request, service returns a 202 to the initial request
     * receing a reponse with an invalid 'Location' and 'Retry-After' headers
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.delete202RetryInvalidHeader = function (callback) {
      var self = this.client;
      // Send request
      this.beginDelete202RetryInvalidHeader(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request
     * receing a reponse with an invalid 'Location' and 'Retry-After' headers
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginDelete202RetryInvalidHeader = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/delete/202/retry/invalidheader';
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
     * The endpoint indicated in the Azure-AsyncOperation header is invalid
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.deleteAsyncRelativeRetryInvalidHeader = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRelativeRetryInvalidHeader(function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running delete request, service returns a 202 to the initial request.
     * The endpoint indicated in the Azure-AsyncOperation header is invalid
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginDeleteAsyncRelativeRetryInvalidHeader = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/deleteasync/retry/invalidheader';
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
    LROSADs.prototype.deleteAsyncRelativeRetryInvalidJsonPolling = function (callback) {
      var self = this.client;
      // Send request
      this.beginDeleteAsyncRelativeRetryInvalidJsonPolling(function (err, result){
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
    LROSADs.prototype.beginDeleteAsyncRelativeRetryInvalidJsonPolling = function (callback) {
      var client = this.client;
      if (!callback) {
        throw new Error('callback cannot be null.');
      }

      // Construct URL
      var requestUrl = this.client.baseUri + 
                       '//lro/error/deleteasync/retry/invalidjsonpolling';
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
     * with invalid 'Location' and 'Retry-After' headers.
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.post202RetryInvalidHeader = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPost202RetryInvalidHeader(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with invalid 'Location' and 'Retry-After' headers.
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPost202RetryInvalidHeader = function (product, callback) {
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
                       '//lro/error/post/202/retry/invalidheader';
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
     * with an entity that contains ProvisioningState=’Creating’. The endpoint
     * indicated in the Azure-AsyncOperation header is invalid.
        * @param {Product} [product] Product to put
        *
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.postAsyncRelativeRetryInvalidHeader = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRelativeRetryInvalidHeader(product, function (err, result){
        if (err) return callback(err);
        self.getPostOrDeleteOperationResult(result, callback);
      });
    }

    /**
     * Long running post request, service returns a 202 to the initial request,
     * with an entity that contains ProvisioningState=’Creating’. The endpoint
     * indicated in the Azure-AsyncOperation header is invalid.
     * @param {Product} [product] Product to put
     *
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPostAsyncRelativeRetryInvalidHeader = function (product, callback) {
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
                       '//lro/error/postasync/retry/invalidheader';
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
        * @param {ProductProperties} [product.properties] 
        *
        * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
        *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.postAsyncRelativeRetryInvalidJsonPolling = function (product, callback) {
      var self = this.client;
      // Send request
      this.beginPostAsyncRelativeRetryInvalidJsonPolling(product, function (err, result){
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
     * @param {ProductProperties} [product.properties] 
     *
     * @param {String} [product.properties.provisioningStateValues] Possible values for this property include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
     *
     * @param {function} callback
     *
     * @returns {Stream} The Response stream
     */
    LROSADs.prototype.beginPostAsyncRelativeRetryInvalidJsonPolling = function (product, callback) {
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
                       '//lro/error/postasync/retry/invalidjsonpolling';
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


module.exports = LROSADs;
