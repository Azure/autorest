/*
 */

/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

var msRestAzure = require('ms-rest-azure');

exports.BaseResource = msRestAzure.BaseResource;
exports.CloudError = msRestAzure.CloudError;
exports.StorageAccountCheckNameAvailabilityParameters = require('./storageAccountCheckNameAvailabilityParameters');
exports.CheckNameAvailabilityResult = require('./checkNameAvailabilityResult');
exports.StorageAccountPropertiesCreateParameters = require('./storageAccountPropertiesCreateParameters');
exports.StorageAccountCreateParameters = require('./storageAccountCreateParameters');
exports.Endpoints = require('./endpoints');
exports.CustomDomain = require('./customDomain');
exports.StorageAccountProperties = require('./storageAccountProperties');
exports.Resource = require('./resource');
exports.StorageAccount = require('./storageAccount');
exports.StorageAccountKeys = require('./storageAccountKeys');
exports.StorageAccountListResult = require('./storageAccountListResult');
exports.StorageAccountPropertiesUpdateParameters = require('./storageAccountPropertiesUpdateParameters');
exports.StorageAccountUpdateParameters = require('./storageAccountUpdateParameters');
exports.StorageAccountRegenerateKeyParameters = require('./storageAccountRegenerateKeyParameters');
exports.UsageName = require('./usageName');
exports.Usage = require('./usage');
exports.UsageListResult = require('./usageListResult');
exports.StorageAccountListResult = require('./storageAccountListResult');
exports.UsageListResult = require('./usageListResult');
