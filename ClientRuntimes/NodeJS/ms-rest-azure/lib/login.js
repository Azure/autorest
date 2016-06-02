// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var adal= require('adal-node');
var async = require('async');

var azureConstants = require('./constants');
var ApplicationTokenCredentials = require('./credentials/applicationTokenCredentials');
var DeviceTokenCredentials = require('./credentials/deviceTokenCredentials');
var UserTokenCredentials = require('./credentials/userTokenCredentials');
var AzureEnvironment = require('./azureEnvironment');

function _createDeviceCredentials(tokenResponse) {
  var options = {};
  options.environment = this.environment;
  options.domain = this.domain;
  options.clientId = this.clientId;
  options.tokenCache = this.tokenCache;
  options.username = tokenResponse.userId;
  options.authorizationScheme = tokenResponse.tokenType;
  var credentials = new DeviceTokenCredentials(options);
  return credentials;
}

function _turnOnLogging() {
  var log = adal.Logging;
  log.setLoggingOptions(
    {
      level : log.LOGGING_LEVEL.VERBOSE,
      log : function (level, message, error) {
        console.info(message);
        if (error) {
          console.error(error);
        }
      }
    });
}

if (process.env['AZURE_ADAL_LOGGING_ENABLED']) {
  _turnOnLogging();
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
 * @param {function} callback
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
 * Provides a UserTokenCredentials object. This method is applicable only for organizational ids that are not 2FA enabled.
 * Otherwise please use interactive login.
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
 * @param {function} callback
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

  if (!options.domain) {
    options.domain = azureConstants.AAD_COMMON_TENANT;
  }

  if (!options.clientId) {
    options.clientId = azureConstants.DEFAULT_ADAL_CLIENT_ID;
  }
  var creds;
  try {
    creds = new UserTokenCredentials(options.clientId, options.domain, username, password, options);
  } catch (err) {
    return callback(err);
  }
  return callback(null, creds);
};

/**
 * Provides an ApplicationTokenCredentials object.
 *
 * @param {string} clientId The active directory application client id also known as the SPN (ServicePrincipal Name). 
 * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
 * for an example.
 * @param {string} secret The application secret for the service principal.
 * @param {string} domain The domain or tenant id containing this application.
 * @param {object} [options] Object representing optional parameters.
 * @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
 * @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
 * @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
 * @param {function} callback
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                            - The Error object if an error occurred, null otherwise.
 *
 *                      {UserTokenCredentials} [credentials]   - The UserTokenCredentials object
 */
exports.withServicePrincipalSecret = function withServicePrincipalSecret(clientId, secret, domain, options, callback) {
  if(!callback && typeof options === 'function') {
    callback = options;
    options = {};
  }
  var creds;
  try {
    creds = new ApplicationTokenCredentials(clientId, domain, secret, options);
  } catch (err) {
    return callback(err);
  }
  return callback(null, creds);
};

exports = module.exports;