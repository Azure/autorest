// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var url = require('url');
var Constants = require('./constants');
var ProxyFilter = require('./filters/proxyFilter');
var RedirectFilter = require('./filters/redirectFilter');
var SigningFilter = require('./filters/signingFilter');
var ExponentialRetryPolicyFilter = require('./filters/exponentialRetryPolicyFilter');
var requestPipeline = require('./requestPipeline');
var utils = require('./utils');

/**
 * @class
 * Initializes a new instance of the ServiceClient class.
 * @constructor
 * @param {object} [credentials]    - BasicAuthenticationCredentials or 
 * TokenCredentials object used for authentication. 
 * 
 * @param {object} [options] The parameter options
 * 
 * @param {Array} [options.filters]         - Filters to be added to the request pipeline
 * 
 * @param {object} [options.requestOptions] - Options for the request object
 * {@link https://github.com/request/request#requestoptions-callback Options doc}
 * 
 * @param {bool} [options.noRetryPolicy] - If set to true, turn off default retry policy
 */
function ServiceClient(credentials, options) {
  if (!options) {
    options = {};
  }
  
  if (!options.requestOptions) {
    options.requestOptions = {};
  }

  if (!options.filters) {
    options.filters = [];
  }
  
  if (credentials && !credentials.signRequest) {
    throw new Error('credentials argument needs to implement signRequest method');
  }

  if (credentials) {
    options.filters.push(SigningFilter.create(credentials));
  }

  options.filters.push(RedirectFilter.create());
  if (!options.noRetryPolicy) {
    options.filters.push(new ExponentialRetryPolicyFilter());
  }

  this.pipeline = requestPipeline.create(options.requestOptions).apply(requestPipeline, options.filters);
  
  // enable network tracing
  this._setDefaultProxy();
}

/*
* Loads the fields "useProxy" and respective protocol, port and url
* from the environment values HTTPS_PROXY and HTTP_PROXY
* in case those are set.
* @ignore
*
* @return {string} or null
*/
ServiceClient._loadEnvironmentProxyValue = function () {
  var proxyUrl = null;
  if (process.env[Constants.HTTPS_PROXY]) {
    proxyUrl = process.env[Constants.HTTPS_PROXY];
  } else if (process.env[Constants.HTTPS_PROXY.toLowerCase()]) {
    proxyUrl = process.env[Constants.HTTPS_PROXY.toLowerCase()];
  } else if (process.env[Constants.HTTP_PROXY]) {
    proxyUrl = process.env[Constants.HTTP_PROXY];
  } else if (process.env[Constants.HTTP_PROXY.toLowerCase()]) {
    proxyUrl = process.env[Constants.HTTP_PROXY.toLowerCase()];
  }

  return proxyUrl;
};

/**
* Sets the service host default proxy from the environment.
* Can be overridden by calling _setProxyUrl or _setProxy
* It is useful for enabling Fiddler trace
*/
ServiceClient.prototype._setDefaultProxy = function () {
  var proxyUrl = ServiceClient._loadEnvironmentProxyValue();
  if (proxyUrl) {
    var parsedUrl = url.parse(proxyUrl);
    if (!parsedUrl.port) {
      parsedUrl.port = 80;
    }

    this.pipeline = requestPipeline.createWithSink(this.pipeline,
      ProxyFilter.create({
        host: parsedUrl.hostname,
        port: parsedUrl.port,
        protocol: parsedUrl.protocol
      },
      utils.urlIsHTTPS(parsedUrl)));
  }
};

/**
* Associate a filtering operation with this ServiceClient. Filtering operations
* can include logging, automatically retrying, etc. Filter operations are functions
* the signature:
*
*     "function (requestOptions, next, callback)".
*
* After doing its preprocessing on the request options, the method needs to call
* "next" passing the current options and a callback with the following signature:
*
*     "function (error, result, response, body)"
*
* In this callback, and after processing the result or response, the callback needs
* invoke the original passed in callback to continue processing other filters and
* finish up the service invocation.
*
* @param {function (requestOptins, next, callback)} filter The new filter object.
* @return {QueueService} A new service client with the filter applied.
*/
ServiceClient.prototype.addFilter = function (newFilter) {
  if (!newFilter) {
    throw new Error('No filter passed');
  }
  if (!(newFilter instanceof Function && newFilter.length === 3)) {
    throw new Error('newFilter must be a function taking three parameters');
  }

  this.pipeline = requestPipeline.createWithSink(this.pipeline, newFilter);
  return this;
};

module.exports = ServiceClient;
