// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var utils = require('./utils');

var nodeVersion = utils.getNodeVersion();
if (nodeVersion.major === 0 && 
	nodeVersion.minor > 8 && 
	!(nodeVersion.minor > 10 || (nodeVersion.minor === 10 && nodeVersion.patch >= 3))) {
  throw new Error('The Microsoft client runtime does not work with node versions > 0.8.22 and ' + 
  	              '< 0.10.3, due to security issues. Please upgrade to node >= 0.10.3');
}

exports.Constants = require('./constants');
exports.Logger = require('./logger');

exports.WebResource = require('./webResource');
exports.ServiceClient = require('./serviceClient');
exports.HttpOperationResponse = require('./httpOperationResponse');

// Credentials
exports.TokenCredentials = require('./credentials/tokenCredentials');
exports.BasicAuthenticationCredentials = require('./credentials/basicAuthenticationCredentials');

// Other filters
exports.ProxyFilter = require('./filters/proxyFilter');
exports.LogFilter = require('./filters/logFilter');
exports.SigningFilter = require('./filters/signingFilter');
exports.ExponentialRetryPolicyFilter = require('./filters/exponentialRetryPolicyFilter');

exports.validate = require('./validate');
exports.requestPipeline = require('./requestPipeline');
exports.serializeObject = require('./serialization').serializeObject;
exports.deserializeDate = require('./serialization').deserializeDate;
exports.isValidISODateTime = require('./serialization').isValidISODateTime;

exports = module.exports;
