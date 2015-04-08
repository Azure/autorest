//
// Copyright (c) Microsoft and contributors.  All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

'use strict';

var url = require('url');

var requestPipeline = require('../http/request-pipeline');
var ErrorHandlingFilter = require('./filters/errorhandlingfilter');
var UserAgentFilter = require('./filters/useragentfilter');
var ProxyFilter = require('./filters/proxyfilter');
var SigningFilter = require('./filters/signingfilter');
var RedirectFilter = require('./filters/redirectfilter');

var ServiceClientConstants = require('./serviceclientconstants');
var azureutil = require('../util/util');

function Service(credentials, filters) {
  if (!filters) {
    filters = [];
  }

  if (!credentials.signRequest) {
    throw new Error('credentials argument needs to implement signRequest method');
  }

  filters.push(SigningFilter.create(credentials));
  filters.push(UserAgentFilter.create());
  filters.push(ErrorHandlingFilter.create());
  filters.push(RedirectFilter.create());

  this.pipeline = requestPipeline.create.apply(requestPipeline, filters);
  
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
Service._loadEnvironmentProxyValue = function () {
  var proxyUrl = null;
  if (process.env[ServiceClientConstants.EnvironmentVariables.HTTPS_PROXY]) {
    proxyUrl = process.env[ServiceClientConstants.EnvironmentVariables.HTTPS_PROXY];
  } else if (process.env[ServiceClientConstants.EnvironmentVariables.HTTPS_PROXY.toLowerCase()]) {
    proxyUrl = process.env[ServiceClientConstants.EnvironmentVariables.HTTPS_PROXY.toLowerCase()];
  } else if (process.env[ServiceClientConstants.EnvironmentVariables.HTTP_PROXY]) {
    proxyUrl = process.env[ServiceClientConstants.EnvironmentVariables.HTTP_PROXY];
  } else if (process.env[ServiceClientConstants.EnvironmentVariables.HTTP_PROXY.toLowerCase()]) {
    proxyUrl = process.env[ServiceClientConstants.EnvironmentVariables.HTTP_PROXY.toLowerCase()];
  }

  return proxyUrl;
};

/**
* Sets the service host default proxy from the environment.
* Can be overridden by calling _setProxyUrl or _setProxy
*
*/
Service.prototype._setDefaultProxy = function () {
  var proxyUrl = Service._loadEnvironmentProxyValue();
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
      azureutil.urlIsHTTPS(parsedUrl)));
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
Service.prototype.withFilter = function (newFilter) {
  if (!newFilter) {
    throw new Error('No filter passed');
  }
  if (!(newFilter instanceof Function && newFilter.length === 3)) {
    throw new Error('newFilter must be a function taking three parameters');
  }

  this.pipeline = requestPipeline.createWithSink(this.pipeline, newFilter);
  return this;
};

/**
* Helper function for generated code - appends new part of the Uri to the base Uri
* ensuring that any duplicate / characters are removed.
*
* @param {string} baseUri     base part of the Uri.
* @param {string} newUriPart  New Uri to be combined to base.
*
* @returns {string} The concatenated Uri.
*/

Service.prototype._appendUri = function (baseUri, newUriPart) {
  if (!baseUri && !newUriPart) {
    return null;
  }

  if (!baseUri) {
    return newUriPart;
  }

  if (!newUriPart) {
    return baseUri;
  }

  if (baseUri[baseUri.length - 1] === '/' && newUriPart[0] === '/') {
    newUriPart = newUriPart.substr(1);
  }

  return baseUri + newUriPart;
};

module.exports = Service;