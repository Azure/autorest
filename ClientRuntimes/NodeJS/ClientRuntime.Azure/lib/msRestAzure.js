// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
'use strict';

exports.AzureServiceClient = require('./azureServiceClient');
exports.UserTokenCredentials = require('./userTokenCredentials');
exports.Resource = require('./resource');
exports.CloudError = require('./cloudError');

exports.generateUuid = require('./utils').generateUuid;

exports = module.exports;