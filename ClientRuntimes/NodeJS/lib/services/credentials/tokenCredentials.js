// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');

var Constants = require('../../util/constants');
var HeaderConstants = Constants.HeaderConstants;

var validate = require('../../util/validate');

var DEFAULT_AUTHORIZATION_SCHEME = 'Bearer';

/**
* Creates a new TokenCredentials object.
*
* @constructor
* @param {string} credentials.authorizationScheme The authorization scheme.
* @param {string} credentials.token               The token.
*/
function TokenCredentials(credentials) {
  validate.validateArgs('TokenCredentials', function (v) {
    v.object(credentials, 'credentials');
    v.string(credentials.token, 'credentials.token');
  });

  if (!credentials.authorizationScheme) {
    credentials.authorizationScheme = DEFAULT_AUTHORIZATION_SCHEME;
  }

  this.credentials = credentials;
}

/**
* Signs a request with the Authentication header.
*
* @param {WebResource} The webresource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
TokenCredentials.prototype.signRequest = function (webResource, callback) {
  webResource.headers[HeaderConstants.AUTHORIZATION] = util.format('%s %s', this.credentials.authorizationScheme, this.credentials.token);

  callback(null);
};

module.exports = TokenCredentials;