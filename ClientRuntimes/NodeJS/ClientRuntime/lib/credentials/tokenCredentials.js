// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var Constants = require('../constants');

var HeaderConstants = Constants.HeaderConstants;
var DEFAULT_AUTHORIZATION_SCHEME = 'Bearer';

/**
* Creates a new TokenCredentials object.
*
* @constructor
* @param {string} token               The token.
* @param {string} authorizationScheme The authorization scheme.
*/
function TokenCredentials(token, authorizationScheme) {
  if (!token) {
    throw new Error('token cannot be null.');
  }
  this.token = token;
  this.authorizationScheme = authorizationScheme;
  if (!this.authorizationScheme) {
    this.authorizationScheme = DEFAULT_AUTHORIZATION_SCHEME;
  }
}

/**
* Signs a request with the Authentication header.
*
* @param {WebResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
TokenCredentials.prototype.signRequest = function (webResource, callback) {
  webResource.headers[HeaderConstants.AUTHORIZATION] = util.format('%s %s', this.authorizationScheme, this.token);

  callback(null);
};

module.exports = TokenCredentials;