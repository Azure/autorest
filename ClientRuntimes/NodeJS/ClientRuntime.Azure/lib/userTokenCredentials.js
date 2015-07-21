// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var msrest = require('ms-rest');
var adal = require('adal-node');
var Constants = msrest.Constants;
var AzureEnvironment = require('./azureEnvironment');

/**
* Creates a new SubscriptionCredentials object.
*
* @constructor
* @param {string} 
* @param {string} authorizationScheme The authorization scheme.
*/
function UserTokenCredentials(clientId, domain, username, password, clientRedirectUri, options) {
  if (Boolean(clientId) || typeof clientId !== 'string') {
    throw new Error('clientId must be a non empty string.');
  }
  
  if (Boolean(domain) || typeof domain !== 'string') {
    throw new Error('domain must be a non empty string.');
  }
  
  if (Boolean(username) || typeof username !== 'string') {
    throw new Error('username must be a non empty string.');
  }
  
  if (Boolean(password) || typeof password !== 'string') {
    throw new Error('password must be a non empty string.');
  }
  
  if (Boolean(clientRedirectUri) || typeof clientRedirectUri !== 'string') {
    throw new Error('clientRedirectUri cannot be null.');
  }
  
  if (!options.environment) {
    this.environment = AzureEnvironment.Azure;
  } else {
    this.environment = options.environment;
  }
  
  if (!options.authorizationScheme) {
    this.authorizationScheme = 'bearer';
  } else {
    this.authorizationScheme = options.authorizationScheme;
  }
  
  this.clientId = clientId;
  this.domain = domain;
  this.username = username;
  this.password = password;
  this.clientRedirectUri = clientRedirectUri;
}

util.inherits(UserTokenCredentials, msrest.TokenCredentials);

/**
* Signs a request with the Authentication header.
*
* @param {webResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
UserTokenCredentials.prototype.signRequest = function (webResource, callback) {
  var authorityUrl = this.environment.authenticationEndpoint + '/' + this.domain;
  var context = new adal.AuthenticationContext(authorityUrl, this.environment.validateAuthority /*,exports.tokenCache*/);
  
  context.acquireToken(this.environment.tokenAudience, this.username, this.clientId, function (err, result) {
    if (err) {
      return callback(new Error('Failed to acquire token. \n' + err));
    }
    
    webResource.headers[Constants.HeaderConstants.AUTHORIZATION] = 
      util.format('%s %s', this.authorizationScheme, result.accessToken);
    callback(null);
  });
};

module.exports = UserTokenCredentials;