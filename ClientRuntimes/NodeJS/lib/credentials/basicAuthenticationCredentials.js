// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var Constants = require('../constants');
var validate = require('../validate');

var HeaderConstants = Constants.HeaderConstants;
var DEFAULT_AUTHORIZATION_SCHEME = 'Basic';

/**
* Creates a new BasicAuthenticationCredentials object.
*
* @constructor
* @param {string} credentials.authorizationScheme    The authorization scheme.
* @param {string} credentials.userName               User name.
* @param {string} credentials.password               Password.
*/
function BasicAuthenticationCredentials(credentials) {
  validate.validateArgs('BasicAuthenticationCredentials', function (v) {
    v.object(credentials, 'credentials');
    v.string(credentials.token, 'credentials.userName');
    v.string(credentials.token, 'credentials.password');
  });

  if (!credentials.authorizationScheme) {
    credentials.authorizationScheme = DEFAULT_AUTHORIZATION_SCHEME;
  }

  this.credentials = credentials;
}

/**
* Signs a request with the Authentication header.
*
* @param {WebResource} The WebResource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
BasicAuthenticationCredentials.prototype.signRequest = function (webResource, callback) {
  webResource.headers[HeaderConstants.AUTHORIZATION] = util.format('%s %s:%s', 
  	this.credentials.authorizationScheme, this.credentials.userName, this.credentials.password);

  callback(null);
};

module.exports = BasicAuthenticationCredentials;