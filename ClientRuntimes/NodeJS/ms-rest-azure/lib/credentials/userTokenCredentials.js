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
* @param {object} [options] Object representing optional parameters.
* @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
* @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
* @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
*/
function UserTokenCredentials(clientId, domain, username, password, options) {
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

  if (!options) {
    options = {};
  }

  if (!options.environment) {
    options.environment = AzureEnvironment.Azure;
  }
  
  if (!options.authorizationScheme) {
    options.authorizationScheme = Constants.HeaderConstants.AUTHORIZATION_SCHEME;
  }

  if (!options.tokenCache) {
    options.tokenCache = new adal.MemoryCache();
  }
  
  this.environment = options.environment;
  this.authorizationScheme = options.authorizationScheme;
  this.tokenCache = options.tokenCache;
  this.clientId = clientId;
  this.domain = domain;
  this.username = username;
  this.password = password;
  var authorityUrl = this.environment.activeDirectoryEndpointUrl + this.domain;
  this.context = new adal.AuthenticationContext(authorityUrl, this.environment.validateAuthority, this.tokenCache);
}

UserTokenCredentials.prototype.retrieveTokenFromCache = function (callback) {
  var self = this;
  self.context.acquireToken(self.environment.activeDirectoryResourceId, self.username, self.clientId, function (err, result) {
    if (err) return callback(err);
    return callback(null, result.tokenType, result.accessToken);
  });
};

/**
* Signs a request with the Authentication header.
*
* @param {webResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
UserTokenCredentials.prototype.signRequest = function (webResource, callback) {
  var self = this;
  this.retrieveTokenFromCache(function(err, scheme, token) {
    if (err) {
      //Some error occured in retrieving the token from cache. May be the cache was empty. Let's try again.
      self.context.acquireTokenWithUsernamePassword(self.environment.activeDirectoryResourceId, self.username, 
        self.password, self.clientId, function (err, tokenResponse) {
          if (err) return callback(new Error('Failed to acquire token for the user. \n' + err));
          webResource.headers[Constants.HeaderConstants.AUTHORIZATION] = util.format('%s %s', tokenResponse.tokenType, tokenResponse.accessToken);
          return callback(null);
        });
    } else {
      webResource.headers[Constants.HeaderConstants.AUTHORIZATION] = util.format('%s %s', scheme, token);
      return callback(null);
    }
  });
};

module.exports = UserTokenCredentials;