// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var exports = module.exports;

var utils = require('./util/util');

var nodeVersion = utils.getNodeVersion();
if (nodeVersion.major === 0 && nodeVersion.minor > 8 && !(nodeVersion.minor > 10 || (nodeVersion.minor === 10 && nodeVersion.patch >= 3))) {
  throw new Error('The Microsoft client runtime does not work with node versions > 0.8.22 and < 0.10.3, due to security issues. Please upgrade to node >= 0.10.3');
}

exports.Constants = require('./util/constants');
exports.Logger = require('./diagnostics/logger');

exports.WebResource = require('./http/webResource');
exports.ServiceClient = require('./services/serviceClient');

// Credentials
exports.TokenCredentials = require('./services/credentials/tokenCredentials');
exports.BasicAuthenticationCredentials = require('./services/credentials/basicAuthenticationCredentials');

// Other filters
exports.LinearRetryPolicyFilter = require('./services/filters/linearRetryPolicyFilter');
exports.ExponentialRetryPolicyFilter = require('./services/filters/exponentialRetryPolicyFilter');
exports.ProxyFilter = require('./services/filters/proxyFilter');
exports.LogFilter = require('./services/filters/logFilter');
exports.SigningFilter = require('./services/filters/signingFilter');

exports.validate = require('./util/validate');
exports.requestPipeline = require('./http/requestPipeline');
