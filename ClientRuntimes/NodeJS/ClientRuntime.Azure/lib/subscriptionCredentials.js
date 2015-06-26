// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');
var msrest = require('ms-rest');

/**
* Creates a new SubscriptionCredentials object.
*
* @constructor
* @param {string} token               The token.
* @param {string} subscriptionId      The subscription id.
* @param {string} authorizationScheme The authorization scheme.
*/
function SubscriptionCredentials(token, subscriptionId, authorizationScheme) {
  if (subscriptionId === null || subscriptionId === undefined || typeof subscriptionId !== 'string') {
    throw new Error('subscriptionId cannot be null.');
  }

  SubscriptionCredentials['super_'].call(this, token, authorizationScheme);
  this.subscriptionId = subscriptionId;
}

util.inherits(SubscriptionCredentials, msrest.TokenCredentials);
module.exports = SubscriptionCredentials;