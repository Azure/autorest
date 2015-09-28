// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var msrest = require('ms-rest');
var adal = require('adal-node');
var Constants = msrest.Constants;

var AzureEnvironment = require('../azureEnvironment');

/**
* Creates a new ApplicationTokenCredentials object.
* See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
* for detailed instructions on creating an Azure Active Directory application.
* @constructor
* @param {string} clientId The active directory application client id. 
* @param {string} domain The domain or tenant id containing this application.
* @param {string} secret The authentication secret for the application.
* @param {object} [options] Object representing optional parameters.
* @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
* @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
* @param {object} [options.tokenCache] The token cache. Default value is null.
*/
function ApplicationTokenCredentials(clientId, domain, secret, options) {
  if (!Boolean(clientId) || typeof clientId.valueOf() !== 'string') {
    throw new Error('clientId must be a non empty string.');
  }
  
  if (!Boolean(domain) || typeof domain.valueOf() !== 'string') {
    throw new Error('domain must be a non empty string.');
  }
  
  if (!Boolean(secret) || typeof secret.valueOf() !== 'string') {
    throw new Error('secret must be a non empty string.');
  }
  
  if (!options) {
    options = {};
  }
  
  if (!options.environment) {
    this.environment = AzureEnvironment.Azure;
  } else {
    this.environment = options.environment;
  }
  
  if (!options.authorizationScheme) {
    this.authorizationScheme = 'Bearer';
  } else {
    this.authorizationScheme = options.authorizationScheme;
  }
  
  this.tokenCache = options.tokenCache;
  this.clientId = clientId;
  this.domain = domain;
  this.secret = secret;
}

/**
* Signs a request with the Authentication header.
*
* @param {webResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
ApplicationTokenCredentials.prototype.signRequest = function (webResource, callback) {
  var self = this;
  var authorityUrl = self.environment.authenticationEndpoint + self.domain;
  var context = new adal.AuthenticationContext(authorityUrl, self.environment.validateAuthority, self.tokenCache);
  
  context.acquireTokenWithClientCredentials(self.environment.tokenAudience, self.clientId, self.secret, function (err, result) {
    if (err) {
      return callback(new Error('Failed to acquire token for application. \n' + err));
    }
    
    webResource.headers[Constants.HeaderConstants.AUTHORIZATION] = 
      util.format('%s %s', self.authorizationScheme, result.accessToken);
    callback(null);
  });
};

module.exports = ApplicationTokenCredentials;