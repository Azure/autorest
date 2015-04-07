// 
// Copyright (c) Microsoft and contributors.  All rights reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 
// See the License for the specific language governing permissions and
// limitations under the License.
// 

var util = require('util');

var Constants = require('../../util/constants');
var HeaderConstants = Constants.HeaderConstants;

var validate = require('../../util/validate');

var DEFAULT_AUTHORIZATION_SCHEME = 'Bearer';

/**
* Creates a new TokenCloudCredentials object.
*
* @constructor
* @param {string} credentials.subscriptionId      The subscription identifier.
* @param {string} credentials.authorizationScheme The authorization scheme.
* @param {string} credentials.token               The token.
*/
function TokenCloudCredentials(credentials) {
  validate.validateArgs('TokenCloudCredentials', function (v) {
    v.object(credentials, 'credentials');
    v.string(credentials.subscriptionId, 'credentials.subscriptionId');
    v.string(credentials.token, 'credentials.token');
  });

  if (!credentials.authorizationScheme) {
    credentials.authorizationScheme = DEFAULT_AUTHORIZATION_SCHEME;
  }

  this.subscriptionId = credentials.subscriptionId;
  this.credentials = credentials;
}

/**
* Signs a request with the Authentication header.
*
* @param {WebResource} The webresource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
TokenCloudCredentials.prototype.signRequest = function (webResource, callback) {
  webResource.headers[HeaderConstants.AUTHORIZATION] = util.format('%s %s', this.credentials.authorizationScheme, this.credentials.token);

  callback(null);
};

module.exports = TokenCloudCredentials;