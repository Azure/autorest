// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var msrest = require('ms-rest');
var adal = require('adal-node');
var Constants = msrest.Constants;

var AzureEnvironment = require('../azureEnvironment');

/**
* Creates a new UserTokenCredentials object.
*
* @constructor
* @param {string} clientId The active directory application client id. 
* See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
* for an example.
* @param {string} domain The domain or tenant id containing this application.
* @param {string} username The user name for the Organization Id account.
* @param {string} password The password for the Organization Id account.
* @param {string} clientRedirectUri The Uri where the user will be redirected after authenticating with AD.
* @param {object} [options] Object representing optional parameters.
* @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
* @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
* @param {object} [options.tokenCache] The token cache. Default value is null.
*/
function UserTokenCredentials(clientId, domain, username, password, clientRedirectUri, options) {
  if (!Boolean(clientId) || typeof clientId.valueOf() !== 'string') {
    throw new Error('clientId must be a non empty string.');
  }
  
  if (!Boolean(domain) || typeof domain.valueOf() !== 'string') {
    throw new Error('domain must be a non empty string.');
  }
  
  if (!Boolean(username) || typeof username.valueOf() !== 'string') {
    throw new Error('username must be a non empty string.');
  }
  
  if (!Boolean(password) || typeof password.valueOf() !== 'string') {
    throw new Error('password must be a non empty string.');
  }
  
  if (!Boolean(clientRedirectUri) || typeof clientRedirectUri.valueOf() !== 'string') {
    throw new Error('clientRedirectUri cannot be null.');
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
  this.username = username;
  this.password = password;
  this.clientRedirectUri = clientRedirectUri;
}

/**
* Signs a request with the Authentication header.
*
* @param {webResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
UserTokenCredentials.prototype.signRequest = function (webResource, callback) {
  var self = this;
  var authorityUrl = self.environment.authenticationEndpoint + self.domain;
  var context = new adal.AuthenticationContext(authorityUrl, self.environment.validateAuthority, self.tokenCache);
  
  context.acquireTokenWithUsernamePassword(self.environment.tokenAudience, self.username, self.password, self.clientId, function (err, result) {
    if (err) {
      return callback(new Error('Failed to acquire token. \n' + err));
    }
    
    webResource.headers[Constants.HeaderConstants.AUTHORIZATION] = 
      util.format('%s %s', self.authorizationScheme, result.accessToken);
    callback(null);
  });
};

module.exports = UserTokenCredentials;