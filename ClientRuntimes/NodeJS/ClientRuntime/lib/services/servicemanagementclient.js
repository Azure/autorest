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

// Module dependencies.
var util = require('util');
var fs = require('fs');
var url = require('url');

var ServiceClient = require('./serviceclient');
var Constants = require('../util/constants');
var ServiceClientConstants = require('./serviceclientconstants');
var HeaderConstants = Constants.HeaderConstants;

/**
* Creates a new ServiceManagementClient object.
*
* @constructor
* @param {object} settingsOrAuthentication Either a settings object or an
*                                          authentication details object
* @param {string} hostOptions             The host options to override defaults.
*                                         {
*                                            host: 'management.core.windows.net',
*                                            port: optional port number
*                                            apiversion: '2012-03-01'
*                                         }
*/
function ServiceManagementClient(settingsOrAuthentication, hostOptions) {
  ServiceManagementClient['super_'].call(this);
  if (settingsOrAuthentication._endpointUri) {
    this._setAuthenticationFromSettings(settingsOrAuthentication);
    this._setServiceHostFromSettings(settingsOrAuthentication);
  } else {
    // TODO: Will remove this path once everything's switched over to new config
    this._setAuthentication(settingsOrAuthentication);
    this._setServiceHost(hostOptions);
  }

  var self = this;

  this.authenticationProvider = {
    signRequest: function (webResource, callback) {
      webResource.authentication = {
        keyvalue: self.keyvalue,
        certvalue: self.certvalue
      };

      callback(null);
    }
  };
}

util.inherits(ServiceManagementClient, ServiceClient);

/**
* Error messages.
*/
ServiceManagementClient.missingKeyValue = 'Client private key certificate is required';
ServiceManagementClient.missingCertValue = 'Client public certificate is required';

// Default API Version
ServiceManagementClient.DefaultAPIVersion = '2012-03-01';

/**
* Sets the client authentication credentials using provided values
* private key and public certificate values may be passed as strings, or will be read from files
*
* @return {Void}
*/
ServiceManagementClient.prototype._setAuthentication = function (authentication) {
  this.keyvalue = null;
  this.certvalue = null;

  if (authentication) {
    if (typeof authentication.keyvalue === 'string' && authentication.keyvalue.length > 0) {
      this.keyvalue = authentication.keyvalue;
    } else if (typeof authentication.keyfile === 'string' && authentication.keyfile.length > 0) {
      this.keyvalue = fs.readFileSync(authentication.keyfile, 'ascii');
    }
    if (typeof authentication.certvalue === 'string' && authentication.certvalue.length > 0) {
      this.certvalue = authentication.certvalue;
    } else if (typeof authentication.certfile === 'string' && authentication.certfile.length > 0) {
      this.certvalue = fs.readFileSync(authentication.certfile, 'ascii');
    }
  }

  if (this.keyvalue === null || this.keyvalue.length === 0) {
    var keyfile = process.env[ServiceClientConstants.EnvironmentVariables.AZURE_KEYFILE];
    if (typeof keyfile === 'string' && keyfile.length > 0) {
      this.keyvalue = fs.readFileSync(keyfile, 'ascii');
    }
  }

  if (this.certvalue === null || this.certvalue.length === 0) {
    var certfile = process.env[ServiceClientConstants.EnvironmentVariables.AZURE_CERTFILE];
    if (typeof certfile === 'string' && certfile.length > 0) {
      this.certvalue = fs.readFileSync(certfile, 'ascii');
    }
  }

  if (this.keyvalue === null || this.keyvalue.length === 0) {
    throw new Error(ServiceManagementClient.missingKeyValue);
  }

  if (this.certvalue === null || this.certvalue.length === 0) {
    throw new Error(ServiceManagementClient.missingCertValue);
  }
};

/**
* Sets the client authentication credentials using the
* values provided in the settings object.
*/
ServiceManagementClient.prototype._setAuthenticationFromSettings = function (settings) {
  this.keyvalue = settings._key;
  this.certvalue = settings._certificate;
};

/**
* Sets the service host options using provided values
* Options are host name, serialization type, and API version string
* If not specified, then the defaults are used
*
* @return {Void}
*/
ServiceManagementClient.prototype._setServiceHost = function (hostOptions) {
  this.host = ServiceClientConstants.CLOUD_SERVICE_MANAGEMENT_HOST;
  this.apiversion = ServiceManagementClient.DefaultAPIVersion;
  this.port = null;
  this.protocol = Constants.HTTPS;

  if (hostOptions) {
    if (hostOptions.host) {
      this.host = hostOptions.host;
    }
    if (hostOptions.apiversion) {
      this.apiversion = hostOptions.apiversion;
    }
    if (hostOptions.port) {
      this.port = hostOptions.port;
    }
  }
};

ServiceManagementClient.prototype._setServiceHostFromSettings = function(settings) {
  this.apiversion = ServiceManagementClient.DefaultAPIVersion;
  var hostUrl = url.parse(settings._endpointUri);
  this.host = hostUrl.hostname;
  this.protocol = hostUrl.protocol;
  this.port = hostUrl.port;
};

/**
* Builds the request options to be passed to the http.request method.
*
* @param {WebResource} webResource The webresource where to build the options from.
* @param {object}      options     The request options.
* @param {function(error, requestOptions)}  callback  The callback function.
* @return {undefined}
*/
ServiceManagementClient.prototype._buildRequestOptions = function (webResource, body, options, callback) {
  if (!webResource.headers || !webResource.headers[HeaderConstants.CONTENT_TYPE]) {
    webResource.withHeader(HeaderConstants.CONTENT_TYPE, 'application/xml');
  }

  if (!webResource.headers || !webResource.headers[HeaderConstants.ACCEPT_HEADER]) {
    webResource.withHeader(HeaderConstants.ACCEPT_HEADER, 'application/xml');
  }

  webResource.withHeader(HeaderConstants.ACCEPT_CHARSET_HEADER, 'UTF-8');
  webResource.withHeader(HeaderConstants.STORAGE_VERSION_HEADER, this.apiversion);

  ServiceManagementClient['super_'].prototype._buildRequestOptions.call(this, webResource, body, options, callback);
};

module.exports = ServiceManagementClient;
