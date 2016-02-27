// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var Constants = require('../constants');

var HeaderConstants = Constants.HeaderConstants;
var DEFAULT_AUTHORIZATION_SCHEME = 'Basic';

/**
* Creates a new BasicAuthenticationCredentials object.
*
* @constructor
* @param {string} userName                 User name.
* @param {string} password                 Password.
* @param {string} [authorizationScheme]    The authorization scheme.
*/
function BasicAuthenticationCredentials(userName, password, authorizationScheme) {
  if (userName === null || userName === undefined || typeof userName.valueOf() !== 'string') {
    throw new Error('userName cannot be null or undefined and must be of type string.');
  }

  if (password === null || password === undefined || typeof password.valueOf() !== 'string') {
    throw new Error('password cannot be null or undefined and must be of type string.');
  }

  this.userName = userName;
  this.password = password;

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
BasicAuthenticationCredentials.prototype.signRequest = function (webResource, callback) {
  var credentials = util.format('%s:%s', 
    this.userName, 
    this.password);

  var encodedCredentials = util.format('%s %s',
    this.authorizationScheme,
    new Buffer(credentials).toString('base64'));
    webResource.headers[HeaderConstants.AUTHORIZATION] = encodedCredentials;

  callback(null);
};

module.exports = BasicAuthenticationCredentials;