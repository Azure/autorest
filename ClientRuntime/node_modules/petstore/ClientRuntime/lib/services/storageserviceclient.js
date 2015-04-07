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

// Module dependencies.
var _ = require('underscore');
var util = require('util');

var azureutil = require('../util/util');

var StorageServiceSettings = require('./storageservicesettings');

var ServiceClient = require('./serviceclient');
var Constants = require('../util/constants');
var ServiceClientConstants = require('./serviceclientconstants');
var HeaderConstants = Constants.HeaderConstants;
var QueryStringConstants = Constants.QueryStringConstants;

/**
* Creates a new ServiceClient object.
*
* @constructor
* @param {string} storageAccount           The storage account.
* @param {string} storageAccessKey         The storage access key.
* @param {string} host                     The host for the service.
* @param {bool}   usePathStyleUri          Boolean value indicating wether to use path style uris.
* @param {object} authenticationProvider   The authentication provider object (e.g. sharedkey / sharedkeytable / sharedaccesssignature).
*/
function StorageServiceClient(storageAccount, storageAccessKey, host, usePathStyleUri, authenticationProvider) {
  this._setAccountCredentials(storageAccount, storageAccessKey);
  this.apiVersion = HeaderConstants.TARGET_STORAGE_VERSION;
  this.usePathStyleUri = usePathStyleUri;

  StorageServiceClient['super_'].call(this, host, authenticationProvider);

  this._initDefaultFilter();
}

util.inherits(StorageServiceClient, ServiceClient);

// Validation error messages
StorageServiceClient.incorrectStorageAccountErr = 'You must supply an account name or use the environment variable AZURE_STORAGE_ACCOUNT if you are not running in the emulator.';
StorageServiceClient.incorrectStorageAccessKeyErr = 'You must supply an account key or use the environment variable AZURE_STORAGE_ACCESS_KEY if you are not running in the emulator.';

/**
* Gets the storage settings.
*
* @param {string} [storageAccountOrConnectionString]  The storage account or the connection string.
* @param {string} [storageAccessKey]                  The storage access key.
* @param {string} [host]                              The host address.
*
* @return {StorageServiceSettings}
*/
StorageServiceClient.getStorageSettings = function (storageAccountOrConnectionString, storageAccessKey, host) {
  var storageServiceSettings;

  if (_.isString(storageAccountOrConnectionString) && !storageAccessKey) {
    // If storageAccountOrConnectionString was passed and no accessKey was passed, assume connection string
    storageServiceSettings = StorageServiceSettings.createFromConnectionString(storageAccountOrConnectionString);
  } else if (!(storageAccountOrConnectionString && storageAccessKey) && ServiceClient.isEmulated()) {
    // Dev storage scenario
    storageServiceSettings = StorageServiceSettings.getDevelopmentStorageAccountSettings();
  } else if (storageAccountOrConnectionString && storageAccessKey) {
    storageServiceSettings = StorageServiceSettings.createExplicitlyOrFromEnvironment(storageAccountOrConnectionString, storageAccessKey, host);
  } else {
    storageServiceSettings = StorageServiceSettings.createFromConfig(storageAccountOrConnectionString);
  }

  return storageServiceSettings;
};

/**
* Builds the request options to be passed to the http.request method.
*
* @param {WebResource} webResource The webresource where to build the options from.
* @param {object}      options     The request options.
* @param {function(error, requestOptions)}  callback  The callback function.
* @return {undefined}
*/
StorageServiceClient.prototype._buildRequestOptions = function (webResource, body, options, callback) {
  webResource.withHeader(HeaderConstants.STORAGE_VERSION_HEADER, this.apiVersion);
  webResource.withHeader(HeaderConstants.DATE_HEADER, new Date().toUTCString());
  webResource.withHeader(HeaderConstants.ACCEPT_HEADER, 'application/atom+xml,application/xml');
  webResource.withHeader(HeaderConstants.ACCEPT_CHARSET_HEADER, 'UTF-8');

  if (options) {
    if (options.timeoutIntervalInMs) {
      webResource.withQueryOption(QueryStringConstants.TIMEOUT, options.timeoutIntervalInMs);
    }

    if (options.accessConditions) {
      webResource.withHeaders(options.accessConditions,
        HeaderConstants.IF_MATCH,
        HeaderConstants.IF_MODIFIED_SINCE,
        HeaderConstants.IF_NONE_MATCH,
        HeaderConstants.IF_UNMODIFIED_SINCE);
    }

    if (options.sourceAccessConditions) {
      webResource.withHeaders(options.sourceAccessConditions,
        HeaderConstants.SOURCE_IF_MATCH_HEADER,
        HeaderConstants.SOURCE_IF_MODIFIED_SINCE_HEADER,
        HeaderConstants.SOURCE_IF_NONE_MATCH_HEADER,
        HeaderConstants.SOURCE_IF_UNMODIFIED_SINCE_HEADER);
    }
  }

  StorageServiceClient['super_'].prototype._buildRequestOptions.call(this, webResource, body, options, callback);
};

/**
* Retrieves the normalized path to be used in a request.
* This takes into consideration the usePathStyleUri object field
* which specifies if the request is against the emulator or against
* the live service. It also adds a leading "/" to the path in case
* it's not there before.
*
* @param {string} path The path to be normalized.
* @return {string} The normalized path.
*/
StorageServiceClient.prototype._getPath = function (path) {
  if (path === null || path === undefined) {
    path = '/';
  } else if (path.indexOf('/') !== 0) {
    path = '/' + path;
  }

  if (this.usePathStyleUri) {
    path = '/' + this.storageAccount + path;
  }

  return path;
};

/**
* Sets the account credentials taking into consideration the isEmulated value and the environment variables:
* AZURE_STORAGE_ACCOUNT and AZURE_STORAGE_ACCESS_KEY.
*
* @param {string} storageAccount          The storage account.
* @param {string} storageAccessKey        The storage access key.
* @return {undefined}
*/
StorageServiceClient.prototype._setAccountCredentials = function (storageAccount, storageAccessKey) {
  if (azureutil.objectIsNull(storageAccount)) {
    if (process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_ACCOUNT]) {
      storageAccount = process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_ACCOUNT];
    } else if (ServiceClient.isEmulated()) {
      storageAccount = ServiceClientConstants.DEVSTORE_STORAGE_ACCOUNT;
    }
  }

  if (azureutil.objectIsNull(storageAccessKey)) {
    if (process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_ACCESS_KEY]) {
      storageAccessKey = process.env[ServiceClient.EnvironmentVariables.AZURE_STORAGE_ACCESS_KEY];
    } else if (ServiceClient.isEmulated()) {
      storageAccessKey = ServiceClient.DEVSTORE_STORAGE_ACCESS_KEY;
    }
  }

  if (!azureutil.objectIsString(storageAccount) || azureutil.stringIsEmpty(storageAccount)) {
    throw new Error(StorageServiceClient.incorrectStorageAccountErr);
  }

  if (!azureutil.objectIsString(storageAccessKey) || azureutil.stringIsEmpty(storageAccessKey)) {
    throw new Error(StorageServiceClient.incorrectStorageAccessKeyErr);
  }

  this.storageAccount = storageAccount;
  this.storageAccessKey = storageAccessKey;
};

module.exports = StorageServiceClient;
