// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

var _ = require('underscore');

/**
 * @class
 * Initializes a new instance of the AzureEnvironment class.
 * @constructor
 * @param {string} authenticationEndpoint - ActiveDirectory Endpoint for the Azure Environment.
 * @param {string} tokenAudience - Token audience for an endpoint.
 * @param {bool} [validateAuthority] - Determines whether the authentication endpoint should 
 * be validated with Azure AD. Default value is true.
 */
function AzureEnvironment(authenticationEndpoint, tokenAudience, validateAuthority) {
  this.authenticationEndpoint = authenticationEndpoint;
  this.tokenAudience = tokenAudience;
  this.validateAuthority = validateAuthority;
}

/**
 * Provides the settings for authentication with Azure
 */
var Azure = new AzureEnvironment('https://login.windows.net/',
                                 'https://management.core.windows.net/',
                                  true);

/**
 * Provides the settings for authentication with Azure China
 */
var AzureChina = new AzureEnvironment('https://login.chinacloudapi.cn/',
                                      'https://management.core.chinacloudapi.cn/',
                                       true);

_.extend(module.exports, {
  Azure: Azure,
  AzureChina: AzureChina,
  AzureEnvironment: AzureEnvironment
});
