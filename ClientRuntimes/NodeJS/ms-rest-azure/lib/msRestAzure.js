// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
'use strict';

exports.AzureServiceClient = require('./azureServiceClient');
exports.UserTokenCredentials = require('./credentials/userTokenCredentials');
exports.ApplicationTokenCredentials = require('./credentials/applicationTokenCredentials');
exports.BaseResource = require('./baseResource');
exports.CloudError = require('./cloudError');
exports.TokenCredentials = require('ms-rest').TokenCredentials;
exports.generateUuid = require('./utils').generateUuid;

exports = module.exports;