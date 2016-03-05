// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var utils = require('./utils');
exports.Constants = require('./constants');

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

exports.requestPipeline = require('./requestPipeline');
exports.stripResponse = utils.stripResponse;
exports.stripRequest = utils.stripRequest;
exports.isValidUuid = utils.isValidUuid;

//serialization
exports.serializeObject = require('./serialization').serializeObject;
exports.serialize = require('./serialization').serialize;
exports.deserialize = require('./serialization').deserialize;
var serialization = require('./serialization');

exports.addSerializationMixin = function (destObject) {
  ['serialize', 'serializeObject', 'deserialize'].forEach(function (property) {
    destObject[property] = serialization[property];
  });
};

exports = module.exports;