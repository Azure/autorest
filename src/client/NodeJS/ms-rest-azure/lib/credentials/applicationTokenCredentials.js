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
* @param {string} [options.tokenAudience] The audience for which the token is requested. Valid value is 'graph'. If tokenAudience is provided 
* then domain should also be provided its value should not be the default 'common' tenant. It must be a string (preferrably in a guid format).
* @param {AzureEnvironment} [options.environment] The azure environment to authenticate with.
* @param {string} [options.authorizationScheme] The authorization scheme. Default value is 'bearer'.
* @param {object} [options.tokenCache] The token cache. Default value is the MemoryCache object from adal.
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
    options.environment = AzureEnvironment.Azure;
  }
  
  if (!options.authorizationScheme) {
    options.authorizationScheme = Constants.HeaderConstants.AUTHORIZATION_SCHEME;
  }

  if (!options.tokenCache) {
    options.tokenCache = new adal.MemoryCache();
  }

  if (options.tokenAudience) {
    if (options.tokenAudience.toLowerCase() !== 'graph') {
      throw new Error('Valid value for \'tokenAudience\' is \'graph\'.');
    }
    if (domain.toLowerCase() === 'common') {
      throw new Error('If the tokenAudience is specified as \'graph\' then \'domain\' cannot be the default \'commmon\' tenant. ' + 
        'It must be the actual tenant (preferrably a string in a guid format).');
    }
  }

  this.tokenAudience = options.tokenAudience;
  this.environment = options.environment;
  this.authorizationScheme = options.authorizationScheme;
  this.tokenCache = options.tokenCache;
  this.clientId = clientId;
  this.domain = domain;
  this.secret = secret;
  var authorityUrl = this.environment.activeDirectoryEndpointUrl + this.domain;
  this.context = new adal.AuthenticationContext(authorityUrl, this.environment.validateAuthority, this.tokenCache);
}

function _removeInvalidEntry(query, callback) {
  var self = this;
  self.tokenCache.find(query, function (err, entries) {
    if (err) return callback(err);
    if (entries && entries.length > 0) {
      return self.tokenCache.remove(entries, callback);
    } else {
      return callback();
    }
  });
}

function _retrieveTokenFromCache(callback) {
  //For service principal userId and clientId are the same thing. Since the token has _clientId property we shall 
  //retrieve token using it.
  var self = this;
  var resource = self.environment.activeDirectoryResourceId;
  if (self.tokenAudience && self.tokenAudience.toLowerCase() === 'graph') resource = self.environment.activeDirectoryGraphResourceId;
  self.context.acquireToken(resource, null, self.clientId, function (err, result) {
    if (err) {
      //make sure to remove the stale token from the tokencache. ADAL gives the same error message "Entry not found in cache."
      //for entry not being present in the cache and for accessToken being expired in the cache. We do not want the token cache 
      //to contain the expired token hence we will search for it and delete it explicitly over here.
      _removeInvalidEntry.call(self, { _clientId: self.clientId}, function (erronRemove) {
        if (erronRemove) {
          return callback(new Error('Error occurred while removing the expired token for service principal from token cache.\n' + erronRemove.message));
        } else {
          return callback(err);
        }
      });
    } else {
      return callback(null, result);
    }
  });
}

/**
 * Tries to get the token from cache initially. If that is unsuccessfull then it tries to get the token from ADAL.
 * @param  {function} callback  The callback in the form (err, result)
 * @return {function} callback
 *                       {Error} [err]  The error if any
 *                       {object} [tokenResponse] The tokenResponse (tokenType and accessToken are the two important properties). 
 */
ApplicationTokenCredentials.prototype.getToken = function (callback) {
  var self = this;
  _retrieveTokenFromCache.call(this, function (err, result) {
    if (err) {
      if (err.message.match(/.*while removing the expired token for service principal.*/i) !== null) {
        return callback(err);
      } else {
        //Some error occured in retrieving the token from cache. May be the cache was empty or the access token expired. Let's try again.
        var resource = self.environment.activeDirectoryResourceId;
        if (self.tokenAudience && self.tokenAudience.toLowerCase() === 'graph') resource = self.environment.activeDirectoryGraphResourceId;
        self.context.acquireTokenWithClientCredentials(resource, self.clientId, self.secret, function (err, tokenResponse) {
          if (err) {
            return callback(new Error('Failed to acquire token for application with the provided secret. \n' + err));
          }
          return callback(null, tokenResponse);
        });
      }
    } else {
      return callback(null, result);
    }
  });
};

/**
* Signs a request with the Authentication header.
*
* @param {webResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
ApplicationTokenCredentials.prototype.signRequest = function (webResource, callback) {
  this.getToken(function (err, result) {
    if (err) return callback(err);
    webResource.headers[Constants.HeaderConstants.AUTHORIZATION] = 
          util.format('%s %s', result.tokenType, result.accessToken);
    return callback(null);
  });
};

module.exports = ApplicationTokenCredentials;