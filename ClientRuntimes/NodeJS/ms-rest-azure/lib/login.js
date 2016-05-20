// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var adal= require('adal-node');
var async = require('async');
var msrest = require('ms-rest');
var Constants = msrest.Constants;

var azureConstants = require('./constants');
var UserTokenCredentials = require('./credentials/UserTokenCredentials');
var DeviceTokeCredentials = require('./credentials/DeviceTokenCredentials');
var AzureEnvironment = require('./azureEnvironment');

function _createDeviceCredentials(tokenResponse) {
  var options = {};
  options.environment = this.environment;
  options.domain = this.domain;
  options.clientId = this.clientId;
  options.tokenCache = this.tokenCache;
  options.username = tokenResponse.userId;
  options.authorizationScheme = tokenResponse.tokenType;
  var credentials = new DeviceTokeCredentials(options);
  return credentials;
}

function _createUserCredentials(tokenResponse) {
  var options = {};
  options.environment = this.environment;
  options.tokenCache = this.tokenCache;
  options.authorizationScheme = tokenResponse.tokenType;
  var credentials = new UserTokenCredentials(self.clientId, self.domain, self.username, self.password, options);
  return credentials;
}

/**
 * Provides a url and code that needs to be copy and pasted in a browser and authenticated over there. If successful, the user will get a 
 * DeviceTokenCredentials object
 *
 * @param {object} [options] Object representing optional parameters.
 *
 * @param {string} [options.clientId] The active directory application client id.
 * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
 * for an example.
 *
 * @param {string} [options.domain] The domain or tenant id containing this application. Default value is 'common'
 *
 * @param {AzureEnvironment} [options.environment] The azure environment to authenticate with. Default environment is "Public Azure".
 *
 * @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
 *
 * @param {object} [options.language] The language code specifying how the message should be localized to. Default value 'en-us'.
 *
 * @param {function} callback The language code specifying how the message should be localized to. Default value 'en-us'.
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                            - The Error object if an error occurred, null otherwise.
 *
 *                      {DeviceTokenCredentials} [credentials]   - The DeviceTokenCredentials object
 */
exports.interactive = function interactive(options, callback) {
  if(!callback && typeof options === 'function') {
    callback = options;
    options = {};
  }

  if (!options.environment) {
    options.environment = AzureEnvironment.Azure;
  }

  if (!options.domain) {
    options.domain = azureConstants.AAD_COMMON_TENANT;
  }

  if (!options.clientId) {
    options.clientId = azureConstants.DEFAULT_ADAL_CLIENT_ID;
  }

  if (!options.tokenCache) {
    options.tokenCache = new adal.MemoryCache();
  }

  if (!options.language) {
    options.language = azureConstants.DEFAULT_LANGUAGE;
  }

  this.environment = options.environment;
  this.domain = options.domain;
  this.clientId = options.clientId;
  this.tokenCache = options.tokenCache;
  this.language = options.language;
  var authorityUrl = this.environment.activeDirectoryEndpointUrl + this.domain;
  this.context = new adal.AuthenticationContext(authorityUrl, this.environment.validateAuthority, this.tokenCache);
  var self = this;
  async.waterfall([
    function (callback) {
      self.context.acquireUserCode(self.environment.activeDirectoryResourceId, self.clientId, self.language, function (err, userCodeResponse) {
        if (err) return callback(err);
        console.log(userCodeResponse.message);
        return callback(null, userCodeResponse);
      });
    },
    function (userCodeResponse, callback) {
      self.context.acquireTokenWithDeviceCode(self.environment.activeDirectoryResourceId, self.clientId, userCodeResponse, function (err, tokenResponse) {
        if (err) return callback(err);
        return callback(null, tokenResponse);
      });
    }
  ], function(err, tokenResponse) {
    if (err) return callback(err);
    return callback(null, _createDeviceCredentials.call(self, tokenResponse));
  });
};

/**
* Provides a UserTokenCredentials object if successful.
*
* @param {string} username The user name for the Organization Id account.
* @param {string} password The password for the Organization Id account.
* @param {object} [options] Object representing optional parameters.
* @param {string} [options.clientId] The active directory application client id. 
* See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
* for an example.
* @param {string} [options.domain] The domain or tenant id containing this application. Default value 'common'.
* @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
* @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
* @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
* @param {function} callback The language code specifying how the message should be localized to. Default value 'en-us'.
*
* @returns {function} callback(err, credentials)
*
*                      {Error}  [err]                            - The Error object if an error occurred, null otherwise.
*
*                      {UserTokenCredentials} [credentials]   - The UserTokenCredentials object
*/
exports.withUsernamePassword = function withUsernamePassword(username, password, options, callback) {
  if(!callback && typeof options === 'function') {
    callback = options;
    options = {};
  }

  if (!Boolean(username) || typeof username.valueOf() !== 'string') {
    throw new Error('username must be a non empty string.');
  }
  
  if (!Boolean(password) || typeof password.valueOf() !== 'string') {
    throw new Error('password must be a non empty string.');
  }

  if (!options.domain) {
    options.domain = azureConstants.AAD_COMMON_TENANT;
  }

  if (!options.clientId) {
    options.clientId = azureConstants.DEFAULT_ADAL_CLIENT_ID;
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
  this.domain = options.domain;
  this.clientId = options.clientId;
  this.username = username;
  this.password = password;
  var authorityUrl = this.environment.activeDirectoryEndpointUrl + this.domain;
  this.context = new adal.AuthenticationContext(authorityUrl, this.environment.validateAuthority, this.tokenCache);
  var self = this;
  self.context.acquireTokenWithUsernamePassword(self.environment.activeDirectoryResourceId, self.username, 
    self.password, self.clientId, function (err, tokenResponse) {
    if (err) return callback(new Error('Failed to acquire token. \n' + err));
    return callback(null, _createUserCredentials.call(self, tokenResponse));
  });
};

exports = module.exports;