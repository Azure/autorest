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

'use strict';

var _ = require('underscore');
var url = require('url');

var util = require('../util/util');
var azure = require('../common');
var ServiceSettings = require('./servicesettings');
var Constants = require('../util/constants');
var ServiceClientConstants = require('./serviceclientconstants');
var ConnectionStringKeys = Constants.ConnectionStringKeys;
var Validate = require('../util/validate');

var devStoreAccount = null;
var useDevelopmentStorageSetting = ServiceSettings.setting(ConnectionStringKeys.USE_DEVELOPMENT_STORAGE_NAME, true);
var developmentStorageProxyUriSetting = ServiceSettings.settingWithFunc(ConnectionStringKeys.DEVELOPMENT_STORAGE_PROXY_URI_NAME, Validate.isValidUri);
var defaultEndpointsProtocolSetting = ServiceSettings.setting(ConnectionStringKeys.DEFAULT_ENDPOINTS_PROTOCOL_NAME, 'http', 'https');
var accountNameSetting = ServiceSettings.setting(ConnectionStringKeys.ACCOUNT_NAME_NAME);
var accountKeySetting = ServiceSettings.settingWithFunc(ConnectionStringKeys.ACCOUNT_KEY_NAME, Validate.isBase64Encoded);

var blobEndpointSetting = ServiceSettings.settingWithFunc(
  ConnectionStringKeys.BLOB_ENDPOINT_NAME,
  Validate.isValidUri
);

var queueEndpointSetting = ServiceSettings.settingWithFunc(
  ConnectionStringKeys.QUEUE_ENDPOINT_NAME,
  Validate.isValidUri
);

var tableEndpointSetting = ServiceSettings.settingWithFunc(
  ConnectionStringKeys.TABLE_ENDPOINT_NAME,
  Validate.isValidUri
);

var validKeys = [
  ConnectionStringKeys.USE_DEVELOPMENT_STORAGE_NAME,
  ConnectionStringKeys.DEVELOPMENT_STORAGE_PROXY_URI_NAME,
  ConnectionStringKeys.DEFAULT_ENDPOINTS_PROTOCOL_NAME,
  ConnectionStringKeys.ACCOUNT_NAME_NAME,
  ConnectionStringKeys.ACCOUNT_KEY_NAME,
  ConnectionStringKeys.BLOB_ENDPOINT_NAME,
  ConnectionStringKeys.QUEUE_ENDPOINT_NAME,
  ConnectionStringKeys.TABLE_ENDPOINT_NAME
];

/**
* Creates new storage service settings instance.
*
* @param {string} name             The storage service name.
* @param {string} key              The storage service key.
* @param {string} blobEndpointUri  The storage service blob endpoint.
* @param {string} queueEndpointUri The storage service queue endpoint.
* @param {string} tableEndpointUri The storage service table endpoint.
* @param {bool}   usePathStyleUri  Boolean value indicating wether to use path style uri or not.
*/
function StorageServiceSettings(name, key, blobEndpointUri, queueEndpointUri, tableEndpointUri, usePathStyleUri) {
  this._name = name;
  this._key = key;

  this._blobEndpointUri  = blobEndpointUri;
  this._queueEndpointUri = queueEndpointUri;
  this._tableEndpointUri = tableEndpointUri;

  if (usePathStyleUri) {
    this._usePathStyleUri = usePathStyleUri;
  } else {
    this._usePathStyleUri = false;
  }
}

/**
* Returns a StorageServiceSettings with development storage credentials using
* the specified proxy Uri.
*
* @param {string} proxyUri The proxy endpoint to use.
* @return {StorageServiceSettings}
*/
StorageServiceSettings._getDevelopmentStorageAccount = function (proxyUri) {
  if (!proxyUri) {
    return StorageServiceSettings.getDevelopmentStorageAccountSettings();
  }

  var parsedUri = url.parse(proxyUri);
  var scheme = parsedUri.protocol;
  var host   = parsedUri.host;
  var prefix = scheme + '//' + host;

  return new StorageServiceSettings(
    Constants.DEV_STORE_NAME,
    Constants.DEV_STORE_KEY,
    prefix + ':10000',
    prefix + ':10001',
    prefix + ':10002',
    true
  );
};

/**
* Gets a StorageServiceSettings object that references the development storage
* account.
*
* @return {StorageServiceSettings}
*/
StorageServiceSettings.getDevelopmentStorageAccountSettings = function () {
  if (!devStoreAccount) {
    devStoreAccount = StorageServiceSettings._getDevelopmentStorageAccount(Constants.DEV_STORE_URI);
  }

  return devStoreAccount;
};

/**
* Gets the default service endpoint using the specified protocol and account
* name.
*
* @param {array}  settings The service settings.
* @param {string} dns      The service DNS.
* @return {string}
*/
StorageServiceSettings._getDefaultServiceEndpoint = function (settings, dns) {
  var scheme = util.tryGetValueInsensitive(
    ConnectionStringKeys.DEFAULT_ENDPOINTS_PROTOCOL_NAME,
    settings
  );

  var accountName = util.tryGetValueInsensitive(
    ConnectionStringKeys.ACCOUNT_NAME_NAME,
    settings
  );

  return url.format({ protocol: scheme, hostname: accountName + '.' + dns });
};


/**
* Creates StorageServiceSettings object given endpoints uri.
*
* @param {array}  settings         The service settings.
* @param {string} blobEndpointUri  The blob endpoint uri.
* @param {string} queueEndpointUri The queue endpoint uri.
* @param {string} tableEndpointUri The table endpoint uri.
* @return {StorageServiceSettings}
*/
StorageServiceSettings._createStorageServiceSettings = function (settings, blobEndpointUri, queueEndpointUri, tableEndpointUri) {
  blobEndpointUri = util.tryGetValueInsensitive(
    ConnectionStringKeys.BLOB_ENDPOINT_NAME,
    settings,
    blobEndpointUri
  );

  queueEndpointUri = util.tryGetValueInsensitive(
    ConnectionStringKeys.QUEUE_ENDPOINT_NAME,
    settings,
    queueEndpointUri
  );

  tableEndpointUri = util.tryGetValueInsensitive(
    ConnectionStringKeys.TABLE_ENDPOINT_NAME,
    settings,
    tableEndpointUri
  );

  var accountName = util.tryGetValueInsensitive(
    ConnectionStringKeys.ACCOUNT_NAME_NAME,
    settings
  );

  var accountKey = util.tryGetValueInsensitive(
    ConnectionStringKeys.ACCOUNT_KEY_NAME,
    settings
  );

  return new StorageServiceSettings(
    accountName,
    accountKey,
    blobEndpointUri,
    queueEndpointUri,
    tableEndpointUri
  );
};

/**
* Creates a ServiceBusSettings object from a set of settings.
*
* @param {object} settings The settings object.
* @return {StorageServiceSettings}
*/
StorageServiceSettings.createFromSettings = function (settings) {
  // Devstore case
  var matchedSpecs = ServiceSettings.matchedSpecification(
    settings,
    ServiceSettings.allRequired(useDevelopmentStorageSetting),
    ServiceSettings.optional(developmentStorageProxyUriSetting)
  );

  if (matchedSpecs) {
    var proxyUri = util.tryGetValueInsensitive(
      ConnectionStringKeys.DEVELOPMENT_STORAGE_PROXY_URI_NAME,
      settings
    );

    return this._getDevelopmentStorageAccount(proxyUri);
  }

  // Automatic case
  matchedSpecs = ServiceSettings.matchedSpecification(
    settings,
    ServiceSettings.allRequired(
      defaultEndpointsProtocolSetting,
      accountNameSetting,
      accountKeySetting
    ),
    ServiceSettings.optional(
      blobEndpointSetting,
      queueEndpointSetting,
      tableEndpointSetting
    )
  );

  if (matchedSpecs) {
    return this._createStorageServiceSettings(
      settings,
      this._getDefaultServiceEndpoint(
        settings,
        ConnectionStringKeys.BLOB_BASE_DNS_NAME
      ),
      this._getDefaultServiceEndpoint(
        settings,
        ConnectionStringKeys.QUEUE_BASE_DNS_NAME
      ),
      this._getDefaultServiceEndpoint(
        settings,
        ConnectionStringKeys.TABLE_BASE_DNS_NAME
      ));
  }

  // Explicit case
  matchedSpecs = ServiceSettings.matchedSpecification(
    settings,
    ServiceSettings.atLeastOne(
      blobEndpointSetting,
      queueEndpointSetting,
      tableEndpointSetting
    ),
    ServiceSettings.allRequired(
      accountNameSetting,
      accountKeySetting
    )
  );

  if (matchedSpecs) {
    return this._createStorageServiceSettings(settings);
  }

  ServiceSettings.noMatchSettings(settings);
};

/**
* Creates a StorageServiceSettings object from the given connection string.
*
* @param {string} connectionString The storage settings connection string.
* @return {StorageServiceSettings}
*/
StorageServiceSettings.createFromConnectionString = function (connectionString) {
  var tokenizedSettings = ServiceSettings.parseAndValidateKeys(connectionString, validKeys);
  try {
    return StorageServiceSettings.createFromSettings(tokenizedSettings);
  } catch (e) {
    if (e instanceof ServiceSettings.NoMatchError) {
      // Replace no match settings exception by no match connection string one.
      ServiceSettings.noMatchConnectionString(connectionString);
    } else {
      throw e;
    }
  }
};

StorageServiceSettings.createExplicitlyOrFromEnvironment = function (storageAccount, storageAccessKey, host) {
  var usePathStyleUri = false;

  if (!storageAccount && process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_CONNECTION_STRING]) {
    return StorageServiceSettings.createFromConnectionString(process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_CONNECTION_STRING]);
  }

  if (!storageAccount) {
    storageAccount = process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_ACCOUNT];
  }

  if (!storageAccessKey) {
    storageAccessKey = process.env[ServiceClientConstants.EnvironmentVariables.AZURE_STORAGE_ACCESS_KEY];
  }

  // Default endpoints
  var blobendpoint = url.format({ protocol: ServiceClientConstants.DEFAULT_PROTOCOL, hostname: storageAccount + '.' + ServiceClientConstants.CLOUD_BLOB_HOST });
  var tableendpoint = url.format({ protocol: ServiceClientConstants.DEFAULT_PROTOCOL, hostname: storageAccount + '.' + ServiceClientConstants.CLOUD_TABLE_HOST });
  var queueendpoint = url.format({ protocol: ServiceClientConstants.DEFAULT_PROTOCOL, hostname: storageAccount + '.' + ServiceClientConstants.CLOUD_QUEUE_HOST });

  if (host) {
    var parsedHost = ServiceSettings.parseHost(host);
    if (StorageServiceSettings.isDevelopmentStorage(storageAccount, storageAccessKey, parsedHost)) {
      usePathStyleUri = true;
      parsedHost.protocol = Constants.HTTP;
    }

    var parsedHostUrl = url.format(parsedHost);
    blobendpoint = parsedHostUrl;
    tableendpoint = parsedHostUrl;
    queueendpoint = parsedHostUrl;
  }

  var settings = {
    accountname: storageAccount,
    accountkey: storageAccessKey,
    blobendpoint: blobendpoint,
    tableendpoint: tableendpoint,
    queueendpoint: queueendpoint
  };

  var storageServiceSettings = StorageServiceSettings.createFromSettings(settings);
  storageServiceSettings._usePathStyleUri = usePathStyleUri;

  return storageServiceSettings;
};


StorageServiceSettings.isDevelopmentStorage = function (account, accountKey, parsedHost) {
  if ((parsedHost.host === Constants.DEV_STORE_BLOB_HOST ||
      parsedHost.host === Constants.DEV_STORE_TABLE_HOST ||
      parsedHost.host === Constants.DEV_STORE_QUEUE_HOST) &&
      (parsedHost.protocol === Constants.HTTP ||
      parsedHost.defaultedProtocol === true)) {
    return true;
  }

  return false;
};

//
// Code to create settings from azure sdk configuration
//

// string keys used to look up values from configuration
var configKeys = {
  ACCOUNT_NAME: 'storage account name',
  KEY: 'storage account key',
  BLOB_ENDPOINT_URI: 'storage account blob endpoint',
  QUEUE_ENDPOINT_URI: 'storage account queue endpoint',
  TABLE_ENDPOINT_URI: 'storage account table endpoint',
  BLOB_AUTH_PROVIDER: 'storage account blob auth provider',
  QUEUE_AUTH_PROVIDER: 'storage account queue auth provider',
  TABLE_AUTH_PROVIDER: 'storage account table auth provider',
  USE_PATH_STYLE_URI: 'storage account use path style uri'
};

function getEndpoint(account, service, protocol, host) {
  var settings = { };
  settings[ConnectionStringKeys.DEFAULT_ENDPOINTS_PROTOCOL_NAME] = protocol || ServiceClientConstants.DEFAULT_PROTOCOL;
  settings[ConnectionStringKeys.ACCOUNT_NAME_NAME] = account;

  var dns;
  if (host) {
    dns = service + '.' + host;
  } else {
    dns = ServiceClientConstants['CLOUD_' + service.toUpperCase() + '_HOST'];
  }

  return StorageServiceSettings._getDefaultServiceEndpoint(settings, dns);
}

/**
* Creates a StorageSettings object from the given configuration.
*
* @param {object} config the configuration object
*
* @return {StorageServiceSettings}
*/
StorageServiceSettings.createFromConfig = function (config) {
  if (!config) {
    config = azure.config.default;
  }

  if (!config.get(configKeys.ACCOUNT_NAME)) {
    return StorageServiceSettings.createExplicitlyOrFromEnvironment();
  }

  return new StorageServiceSettings(
    config.get(configKeys.ACCOUNT_NAME),
    config.get(configKeys.KEY),
    config.get(configKeys.BLOB_ENDPOINT_URI),
    config.get(configKeys.QUEUE_ENDPOINT_URI),
    config.get(configKeys.TABLE_ENDPOINT_URI),
    config.get(configKeys.USE_PATH_STYLE_URI));
};

/* jshint -W040 */
function configFromOptions(options) {
  var config = this;

  function setOption(value, configKey) {
    if (value) {
      config.set(configKeys[configKey], value);
    }
  }

  setOption(options.account, 'ACCOUNT_NAME');
  setOption(options.key, 'KEY');
  config.set(configKeys.BLOB_ENDPOINT_URI, getEndpoint(options.account, 'blob', options.protocol, options.host));
  config.set(configKeys.QUEUE_ENDPOINT_URI, getEndpoint(options.account, 'queue', options.protocol, options.host));
  config.set(configKeys.TABLE_ENDPOINT_URI, getEndpoint(options.account, 'table', options.protocol, options.host));

  return this;
}
/* jshint +W040 */

/* jshint -W040 */
function configFromNameAndKey(name, key) {
  configFromOptions.call(this, {
    account: name,
    key: key
  });
  return this;
}

function configFromConnectionString(connectionString) {
  var settings = StorageServiceSettings.createFromConnectionString(connectionString);
  this.set(configKeys.ACCOUNT_NAME, settings._name);
  this.set(configKeys.KEY, settings._key);
  this.set(configKeys.BLOB_ENDPOINT_URI, settings._blobEndpointUri);
  this.set(configKeys.QUEUE_ENDPOINT_URI, settings._queueEndpointUri);
  this.set(configKeys.TABLE_ENDPOINT_URI, settings._tableEndpointUri);
  return this;
}

function configDevStorage() {
  this.set(configKeys.ACCOUNT_NAME, ServiceClientConstants.DEVSTORE_STORAGE_ACCOUNT);
  this.set(configKeys.KEY, ServiceClientConstants.DEVSTORE_STORAGE_ACCESS_KEY);
  this.set(configKeys.BLOB_ENDPOINT_URI, ServiceClientConstants.DEVSTORE_DEFAULT_PROTOCOL + ServiceClientConstants.DEVSTORE_BLOB_HOST);
  this.set(configKeys.QUEUE_ENDPOINT_URI, ServiceClientConstants.DEVSTORE_DEFAULT_PROTOCOL + ServiceClientConstants.DEVSTORE_QUEUE_HOST);
  this.set(configKeys.TABLE_ENDPOINT_URI, ServiceClientConstants.DEVSTORE_DEFAULT_PROTOCOL + ServiceClientConstants.DEVSTORE_TABLE_HOST);
  this.set(configKeys.USE_PATH_STYLE_URI, true);
  return this;
}

/* jshint +W040 */

StorageServiceSettings.customizeConfig = function (config) {
  config.storage = function () {
    if (arguments.length === 2) {
      return configFromNameAndKey.apply(this, arguments);
    } else if (arguments.length === 1 && _.isString(arguments[0])) {
      return configFromConnectionString.apply(this, arguments);
    } else if (arguments.length === 1 && _.isObject(arguments[0])) {
      return configFromOptions.apply(this, arguments);
    }
  };

  config.devStorage = configDevStorage;
};

module.exports = StorageServiceSettings;