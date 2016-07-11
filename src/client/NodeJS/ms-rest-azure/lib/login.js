// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var adal= require('adal-node');
var async = require('async');
var util = require('util');
var azureConstants = require('./constants');
var ApplicationTokenCredentials = require('./credentials/applicationTokenCredentials');
var DeviceTokenCredentials = require('./credentials/deviceTokenCredentials');
var UserTokenCredentials = require('./credentials/userTokenCredentials');
var AzureEnvironment = require('./azureEnvironment');
var SubscriptionClient = require('azure-arm-resource').SubscriptionClient;

// It will create a DeviceTokenCredentials object by default
function _createCredentials(parameters) {
  var options = {};
  options.environment = this.environment;
  options.domain = this.domain;
  options.clientId = this.clientId;
  options.tokenCache = this.tokenCache;
  options.username = this.username;
  options.authorizationScheme = this.authorizationScheme;
  options.tokenAudience = this.tokenAudience;
  if (parameters) {
    if (parameters.domain) {
      options.domain = parameters.domain;
    }
    if (parameters.environment) {
      options.environment = parameters.environment;
    }
    if (parameters.userId) {
      options.username = parameters.userId;
    }
    if (parameters.tokenCache) {
      options.tokenCache = parameters.tokenCache;
    }
    if (parameters.tokenAudience) {
      options.tokenAudience = parameters.tokenAudience;
    }
  }
  var credentials;
  if (UserTokenCredentials.prototype.isPrototypeOf(this)) {
    credentials = new UserTokenCredentials(options.clientId, options.domain, options.username, this.password, options);
  } else if (ApplicationTokenCredentials.prototype.isPrototypeOf(this)) {
    credentials = new ApplicationTokenCredentials(options.clientId, options.domain, this.secret, options);
  } else {
    credentials = new DeviceTokenCredentials(options);
  }
  return credentials;
}

function buildTenantList(credentials, callback) {
  var tenants = [];
  if (credentials.domain && credentials.domain !== azureConstants.AAD_COMMON_TENANT) {
    return callback(null, [credentials.domain]);
  }
  var client = new SubscriptionClient(credentials, credentials.environment.resourceManagerEndpointUrl);
  client.tenants.list(function (err, result) {
    async.eachSeries(result, function (tenantInfo, cb) {
      tenants.push(tenantInfo.tenantId);
      cb(err);
    }, function (err) {
      callback(err, tenants);
    });
  });
}

function getSubscriptionsFromTenants(tenantList, callback) {
  var self = this;
  var subscriptions = [];
  var userType = 'user';
  var username = self.username;
  if (ApplicationTokenCredentials.prototype.isPrototypeOf(self)) {
    userType = 'servicePrincipal';
    username = self.clientId;
  }
  async.eachSeries(tenantList, function (tenant, cb) {
    var creds = _createCredentials.call(self, { domain: tenant });
    var client = new SubscriptionClient(creds, creds.environment.resourceManagerEndpointUrl);
    client.subscriptions.list(function (err, result) {
      if (!err) {
        if (result && result.length > 0) {
          subscriptions = subscriptions.concat(result.map(function (s) {
            s.tenantId = tenant;
            s.user = { name: username, type: userType };
            s.environmentName = creds.environment.name;
            s.name = s.displayName;
            s.id = s.subscriptionId;
            delete s.displayName;
            delete s.subscriptionId;
            delete s.subscriptionPolicies;
            return s;
          }));
        }
      }
      return cb(err);
    });
  }, function (err) {
    callback(err, subscriptions);
  });
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

function _crossCheckUserNameWithToken(usernameFromMethodCall, userIdFromToken) {
  //to maintain the casing consistency between 'azureprofile.json' and token cache. (RD 1996587)
  //use the 'userId' here, which should be the same with "username" except the casing.
  if (usernameFromMethodCall.toLowerCase() === userIdFromToken.toLowerCase()) {
    return userIdFromToken;
  } else {
    throw new Error(util.format('The userId of \'%s\' in access token doesn\'t match the username from method call \'%s\'', 
      userIdFromToken, usernameFromMethodCall));
  }
}

/**
 * Provides a url and code that needs to be copy and pasted in a browser and authenticated over there. If successful, the user will get a 
 * DeviceTokenCredentials object and the list of subscriptions associated with that userId across all the applicable tenants.
 *
 * @param {object} [options] Object representing optional parameters.
 *
 * @param {string} [options.clientId] The active directory application client id.
 * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
 * for an example.
 *
 * @param {string} [options.tokenAudience] The audience for which the token is requested. Valid value is 'graph'.If tokenAudience is provided 
 * then domain should also be provided its value should not be the default 'common' tenant. It must be a string (preferrably in a guid format).
 *
 * @param {string} [options.domain] The domain or tenant id containing this application. Default value is 'common'.
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
 *                      {Error}  [err]                           - The Error object if an error occurred, null otherwise.
 *                      {DeviceTokenCredentials} [credentials]   - The DeviceTokenCredentials object
 *                      {Array}                  [subscriptions] - List of associated subscriptions across all the applicable tenants.
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

  this.tokenAudience = options.tokenAudience;
  this.environment = options.environment;
  this.domain = options.domain;
  this.clientId = options.clientId;
  this.tokenCache = options.tokenCache;
  this.language = options.language;
  var authorityUrl = this.environment.activeDirectoryEndpointUrl + this.domain;
  this.context = new adal.AuthenticationContext(authorityUrl, this.environment.validateAuthority, this.tokenCache);
  var self = this;
  var tenantList = [];
  async.waterfall([
    //acquire usercode
    function (callback) {
      self.context.acquireUserCode(self.environment.activeDirectoryResourceId, self.clientId, self.language, function (err, userCodeResponse) {
        if (err) return callback(err);
        console.log(userCodeResponse.message);
        return callback(null, userCodeResponse);
      });
    },
    //acquire token with device code and set the username to userId received from tokenResponse.
    function (userCodeResponse, callback) {
      self.context.acquireTokenWithDeviceCode(self.environment.activeDirectoryResourceId, self.clientId, userCodeResponse, function (err, tokenResponse) {
        if (err) return callback(err);
        self.username = tokenResponse.userId;
        self.authorizationScheme = tokenResponse.tokenType;
        return callback(null);
      });
    },
    //get the list of tenants
    function (callback) {
      var credentials = _createCredentials.call(self);
      buildTenantList(credentials, callback);
    },
    //build the token cache by getting tokens for all the tenants. We will acquire token from adal only when a request is sent. This is good as we also need
    //to build the list of subscriptions across all tenants. So let's build both at the same time :).
    function (tenants, callback) {
      tenantList = tenants;
      if (self.tokenAudience && self.tokenAudience.toLowerCase() === 'graph') {
        // we dont need to get the subscriptionList if the tokenAudience is graph as graph clients are tenant based.
        return callback(null, []);
      } else {
        return getSubscriptionsFromTenants.call(self, tenants, callback);
      }
    }
  ], function(err, subscriptions) {
    if (err) return callback(err);
    return callback(null, _createCredentials.call(self), subscriptions);
  });
};

/**
 * Provides a UserTokenCredentials object and the list of subscriptions associated with that userId across all the applicable tenants. 
 * This method is applicable only for organizational ids that are not 2FA enabled otherwise please use interactive login.
 *
 * @param {string} username The user name for the Organization Id account.
 * @param {string} password The password for the Organization Id account.
 * @param {object} [options] Object representing optional parameters.
 * @param {string} [options.clientId] The active directory application client id. 
 * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
 * for an example.
 * @param {string} [options.tokenAudience] The audience for which the token is requested. Valid value is 'graph'. If tokenAudience is provided 
 * then domain should also be provided and its value should not be the default 'common' tenant. It must be a string (preferrably in a guid format).
 * @param {string} [options.domain] The domain or tenant id containing this application. Default value 'common'.
 * @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
 * @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
 * @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
 * @param {function} callback
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                         - The Error object if an error occurred, null otherwise.
 *                      {UserTokenCredentials} [credentials]   - The UserTokenCredentials object
 *                      {Array}                [subscriptions] - List of associated subscriptions across all the applicable tenants.
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
  var tenantList = [];
  try {
    creds = new UserTokenCredentials(options.clientId, options.domain, username, password, options);
  } catch (err) {
    return callback(err);
  }
  creds.getToken(function (err, result) {
    if (err) return callback(err);
    creds.username = _crossCheckUserNameWithToken(username, result.userId);
    async.waterfall([
      function (callback) {
        buildTenantList(creds, callback);
      },
      function (tenants, callback) {
        tenantList = tenants;
        if (options.tokenAudience && options.tokenAudience.toLowerCase() === 'graph') {
          // we dont need to get the subscriptionList if the tokenAudience is graph as graph clients are tenant based.
          return callback(null, []);
        } else {
          return getSubscriptionsFromTenants.call(options, tenants, callback);
        }
      },
    ], function (err, subscriptions) {
      return callback(null, creds, subscriptions);
    });
  });
};

/**
 * Provides an ApplicationTokenCredentials object and the list of subscriptions associated with that servicePrinicpalId/clientId across all the applicable tenants.
 *
 * @param {string} clientId The active directory application client id also known as the SPN (ServicePrincipal Name). 
 * See {@link https://azure.microsoft.com/en-us/documentation/articles/active-directory-devquickstarts-dotnet/ Active Directory Quickstart for .Net} 
 * for an example.
 * @param {string} secret The application secret for the service principal.
 * @param {string} domain The domain or tenant id containing this application.
 * @param {object} [options] Object representing optional parameters.
 * @param {string} [options.tokenAudience] The audience for which the token is requested. Valid value is 'graph'.
 * @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
 * @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
 * @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
 * @param {function} callback
 *
 * @returns {function} callback(err, credentials)
 *
 *                      {Error}  [err]                         - The Error object if an error occurred, null otherwise.
 *                      {UserTokenCredentials} [credentials]   - The UserTokenCredentials object
 *                      {Array}                [subscriptions] - List of associated subscriptions across all the applicable tenants.
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
  creds.getToken(function (err) {
    if (err) return callback(err);
    if (options.tokenAudience && options.tokenAudience.toLowerCase() === 'graph') {
      // we dont need to get the subscriptionList if the tokenAudience is graph as graph clients are tenant based.
      return callback(null, creds, []);
    } else {
      getSubscriptionsFromTenants.call(creds, [domain], function (err, subscriptions) {
        if (err) return callback(err);
        return callback(null, creds, subscriptions);
      });
    }
  });
};

exports = module.exports;