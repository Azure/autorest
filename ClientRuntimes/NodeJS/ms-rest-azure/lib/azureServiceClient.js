// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 
'use strict';

var util = require('util');
var async = require('async');
var msRest = require('ms-rest');
var PollingState = require('./pollingState');
var LroStates = require('./constants').LongRunningOperationStates;
var WebResource = msRest.WebResource;

/**
 * @class
 * Initializes a new instance of the AzureServiceClient class.
 * @constructor
 * @param {object} credentials - ApplicationTokenCredentials or 
 * UserTokenCredentials object used for authentication.  
 * 
 * @param {object} options - The parameter options used by ServiceClient
 *
 * @param {string} [options.acceptLanguage] - Gets or sets the preferred language for the response. 
 * Default value is: 'en-US'.
 *  
 * @param {boolean} [options.generateClientRequestId] - When set to true a unique x-ms-client-request-id value 
 * is generated and included in each request. Default is true.
 * 
 * @param {number} [options.longRunningOperationRetryTimeout] - Gets or sets the retry timeout in seconds for 
 * Long Running Operations. Default value is 30.
 *
 */
function AzureServiceClient(credentials, options) {
  if (!credentials) {
    throw new Error('Azure clients require credentials.');
  }
  
  AzureServiceClient['super_'].call(this, credentials, options);
  
  this.acceptLanguage = 'en-US';
  this.generateClientRequestId = true;
  this.longRunningOperationRetryTimeout = 30;

  if (!options) options = {};
  
  if (options.acceptLanguage !== null && options.acceptLanguage !== undefined) {
    this.acceptLanguage = options.acceptLanguage;
  }

  if (options.generateClientRequestId !== null && options.generateClientRequestId !== undefined) {
    this.generateClientRequestId = options.generateClientRequestId;
  }

  if (options.longRunningOperationRetryTimeout !== null && options.longRunningOperationRetryTimeout !== undefined) {
    this.longRunningOperationRetryTimeout = options.longRunningOperationRetryTimeout;
  }
}

util.inherits(AzureServiceClient, msRest.ServiceClient);

/**
 * Poll Azure long running PUT or PATCH operation. (Deprecated, new version of the code-gen will generate code to call getLongRunningOperationResult)
 * @param {object} [resultOfInitialRequest] - Response of the initial request for the long running operation.
 * @param {object} [options]
 * @param {object} [options.customHeaders] headers that will be added to request
 */
AzureServiceClient.prototype.getPutOrPatchOperationResult = function (resultOfInitialRequest, options, callback) {
  return this.getLongRunningOperationResult(resultOfInitialRequest, options, callback);
};

/**
 * Poll Azure long running POST or DELETE operations. (Deprecated, new version of the code-gen will generate code to call getLongRunningOperationResult)
 * @param {object} [resultOfInitialRequest] - result of the initial request.
 * @param {object} [options]
 * @param {object} [options.customHeaders] headers that will be added to request
 */
AzureServiceClient.prototype.getPostOrDeleteOperationResult = function (resultOfInitialRequest, options, callback) {
  return this.getLongRunningOperationResult(resultOfInitialRequest, options, callback);
};

/**
 * Poll Azure long running PUT, PATCH, POST or DELETE operations.
 * @param {object} [resultOfInitialRequest] - result of the initial request.
 * @param {object} [options]
 * @param {object} [options.customHeaders] headers that will be added to request
 */
AzureServiceClient.prototype.getLongRunningOperationResult = function (resultOfInitialRequest, options, callback) {
  var self = this;
  
  if (!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('Missing callback');
  }

  if (!resultOfInitialRequest) {
    return callback(new Error('Missing resultOfInitialRequest parameter'));
  }
  
  if (!resultOfInitialRequest.response) {
    return callback(new Error('Missing resultOfInitialRequest.response'));
  }
  
  if (!resultOfInitialRequest.request) {
    return callback(new Error('Missing resultOfInitialRequest.request'));
  }
  
  if (!resultOfInitialRequest.request.method) {
    return callback(new Error('Missing resultOfInitialRequest.request.method'));
  }

  var initialRequestMethod = resultOfInitialRequest.request.method;
  
  if (this._checkResponseStatusCodeFailed(resultOfInitialRequest)) {
    return callback(new Error(util.format('Unexpected polling status code from long running operation \'%s\' for method \'%s\'',
      resultOfInitialRequest.response.statusCode,
	  initialRequestMethod)));
  }
  
  var pollingState = null;
  
  try {
    pollingState = new PollingState(resultOfInitialRequest, this.longRunningOperationRetryTimeout);
  } catch (error) {
    callback(error);
  }
  var resourceUrl = resultOfInitialRequest.request.url;
  this._options = options;

  async.whilst(
    function() {
      var finished = [LroStates.Succeeded, LroStates.Failed, LroStates.Canceled].some(function(e) {
        return e === pollingState.status;
      });
      return !finished;
    },
    function (callback) {
      setTimeout(function() {
        if (pollingState.azureAsyncOperationHeaderLink) {
          self._updateStateFromAzureAsyncOperationHeader(pollingState, true, function(err) {
            return callback(err);
          });
        } else if (pollingState.locationHeaderLink) {
          self._updateStateFromLocationHeader(initialRequestMethod, pollingState, function(err) {
            return callback(err);
          });
        } else if (initialRequestMethod === 'PUT') {
          self._updateStateFromGetResourceOperation(resourceUrl, pollingState, function(err) {
            return callback(err);
          });
        } else {
          return callback(new Error('Location header is missing from long running operation.'));
        }
      }, pollingState.getTimeout());
    },
    //when done
    function (err) {
      if (pollingState.status === LroStates.Succeeded) {
        if ((pollingState.azureAsyncOperationHeaderLink || !pollingState.resource) &&
			(initialRequestMethod === 'PUT' || initialRequestMethod === 'PATCH')) {
          self._updateStateFromGetResourceOperation(resourceUrl, pollingState, function(err) {
            return callback(err, pollingState.getOperationResponse());
          });
        } else {
          return callback(null, pollingState.getOperationResponse());
        }
      } else {
        return callback(pollingState.getCloudError(err));
      }
    });
};

AzureServiceClient.prototype._checkResponseStatusCodeFailed = function (initialRequest) {
  var statusCode = initialRequest.response.statusCode;
  var method = initialRequest.request.method;
  if (statusCode === 200 || statusCode === 202 ||
    (statusCode === 201 && method === 'PUT') ||
    (statusCode === 204 && (method === 'DELETE' || method === 'POST'))) {
    return false;
  } else {
	  return true;
  }
};


/**
 * Retrieve operation status by polling from 'azure-asyncoperation' header.
 * @param {object} [pollingState] - The object to persist current operation state.
 * @param {boolean} [inPostOrDelete] - Invoked by Post Or Delete operation.
 */
AzureServiceClient.prototype._updateStateFromAzureAsyncOperationHeader = function (pollingState, inPostOrDelete, callback) {
  this._getStatus(pollingState.azureAsyncOperationHeaderLink, function (err, result) {
    if (err) return callback(err);
    
    if (!result.body || !result.body.status) {
      return callback(new Error('The response from long running operation does not contain a body.'));
    }
    
    pollingState.status = result.body.status;
    pollingState.error = result.body.error;
    pollingState.response = result.response;
    pollingState.request = result.request;
    pollingState.resource = null;
    if (inPostOrDelete) {
      pollingState.resource = result.body;
    }
    callback(null);
  });
};

/**
 * Retrieve PUT operation status by polling from 'location' header.
 * @param {object} [pollingState] - The object to persist current operation state.
 */
AzureServiceClient.prototype._updateStateFromLocationHeader = function (method, pollingState, callback) {
  this._getStatus(pollingState.locationHeaderLink, function(err, result) {
    if (err) return callback(err);
    
    pollingState.updateResponse(result.response);
    pollingState.request = result.request;
    
    var statusCode = result.response.statusCode;
    if (statusCode === 202) {
      pollingState.status = LroStates.InProgress;
    } else if (statusCode === 200 ||
      (statusCode === 201 && method === 'PUT') ||
      (statusCode === 204 && (method === 'DELETE' || method === 'POST'))) {

      pollingState.status = LroStates.Succeeded;

      pollingState.error = {
        code: pollingState.Status,
        message: util.format('Long running operation failed with status \'%s\'.', pollingState.status)
      };
      pollingState.resource = result.body;
    } else {
	  return callback(new Error('The response from long running operation does not have a valid status code.'));
	}
    callback(null);
  });
};

/**
 * Polling for resource status.
 * @param {function} [resourceUrl] - The url of resource.
 * @param {object} [pollingState] - The object to persist current operation state.
 */
AzureServiceClient.prototype._updateStateFromGetResourceOperation = function (resourceUrl, pollingState, callback) {
  this._getStatus(resourceUrl, function (err, result) {
    if (err) return callback(err);
    if (!result.body) {
      return callback(new Error('The response from long running operation does not contain a body.'));
    }
    
    if (result.body.properties && result.body.properties.provisioningState) {
      pollingState.status = result.body.properties.provisioningState;
    } else {
      pollingState.status = LroStates.Succeeded;
    }
    
    //we might not throw an error, but initialize here just in case.
    pollingState.error = {
      code: pollingState.status,
      message: util.format('Long running operation failed with status \'%s\'.', pollingState.status)
    };
    
    pollingState.updateResponse(result.response);
    pollingState.request = result.request;
    pollingState.resource = result.body;
    
    //nothing to return, the 'pollingState' has all the info we care.
    callback(null);
  });
};

/**
 * Retrieve operation status by querying the operation URL.
 * @param {string} [operationUrl] - URL used to poll operation result.
 */
AzureServiceClient.prototype._getStatus = function (operationUrl, callback) {
  var self = this;
  if (!operationUrl) {
    return callback(new Error('operationUrl cannot be null.'));
  }
  
  // Construct URL
  var requestUrl = operationUrl.replace(' ', '%20');
  
  // Create HTTP transport objects
  var httpRequest = new WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  if(this._options) {
    for (var headerName in this._options['customHeaders']) {
      if (this._options['customHeaders'].hasOwnProperty(headerName)) {
        httpRequest.headers[headerName] = this._options['customHeaders'][headerName];
      }
    }
  }
  // Send Request
  return self.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    if (statusCode !== 200 && statusCode !== 201 && statusCode !== 202 && statusCode !== 204) {
      var error = new Error(util.format('Invalid status code with response body "%s" occurred ' + 
        'when polling for operation status.', responseBody));
      error.statusCode = response.statusCode;
      error.request = msRest.stripRequest(httpRequest);
      error.response = msRest.stripResponse(response);
      if (responseBody === '') responseBody = null;
      try {
        error.body = JSON.parse(responseBody);

      } catch (badResponse) {
        error.message += util.format(' Could not deserialize error response body - "%s" -.', responseBody);
        error.body = responseBody;
      }

      return callback(error);
    }
    // Create Result
    var result = new msRest.HttpOperationResponse();
    result.request = httpRequest;
    result.response = response;
    if (responseBody === '') responseBody = null;
    if (statusCode === 200 || statusCode === 201 || statusCode === 202) {
      try {
        result.body = JSON.parse(responseBody);
      } catch (deserializationError) {
        var parseError = new Error(util.format('Error "%s" occurred in deserializing the response body - "%s" -' + 
        ' when polling for operation status.', deserializationError, responseBody));
        parseError.request = msRest.stripRequest(httpRequest);
        parseError.response = msRest.stripResponse(response);
        parseError.body = responseBody;
        return callback(parseError);
      }
    }
    return callback(null, result);
  });
};

module.exports = AzureServiceClient;