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

var _ = require('underscore');
var url = require('url');
var nodeutil = require('util');

var azureCommon = require('../common');
var util = require('../util/util');
var ServiceSettings = require('./servicesettings');
var Constants = require('../util/constants');
var ConnectionStringKeys = Constants.ConnectionStringKeys;
var ServiceClientConstants = require('./serviceclientconstants');
var EnvironmentVariables = ServiceClientConstants.EnvironmentVariables;
var Validate = require('../util/validate');

var serviceBusEndpointSetting = ServiceSettings.settingWithFunc(ConnectionStringKeys.SERVICE_BUS_ENDPOINT_NAME, Validate.isValidUri);
var wrapEndpointSetting = ServiceSettings.settingWithFunc(ConnectionStringKeys.WRAP_ENDPOINT_NAME, Validate.isValidUri);
var wrapNameSetting = ServiceSettings.setting(ConnectionStringKeys.SHARED_SECRET_ISSUER_NAME);
var wrapPasswordSetting = ServiceSettings.setting(ConnectionStringKeys.SHARED_SECRET_VALUE_NAME);
var sharedAccessKeyNameSetting = ServiceSettings.setting(ConnectionStringKeys.SHARED_ACCESS_KEY_NAME);
var sharedAccessKeySetting = ServiceSettings.setting(ConnectionStringKeys.SHARED_ACCESS_KEY);

var validKeys = [
  ConnectionStringKeys.SERVICE_BUS_ENDPOINT_NAME,
  ConnectionStringKeys.WRAP_ENDPOINT_NAME,
  ConnectionStringKeys.SHARED_SECRET_ISSUER_NAME,
  ConnectionStringKeys.SHARED_SECRET_VALUE_NAME,
  ConnectionStringKeys.SHARED_ACCESS_KEY_NAME,
  ConnectionStringKeys.SHARED_ACCESS_KEY
];

/**
* Creates new service bus settings instance.
*
* @param {string} serviceBusEndpointUri The Service Bus endpoint uri.
* @param {string} wrapEndpointUri       The Service Bus endpoint uri.
* @param {string} namespace             The service namespace.
* @param {string} wrapName              The wrap name.
* @param {string} wrapPassword          The wrap password.
* @param {string} sharedAccessKeyName   The shared access key name.
* @param {string} sharedAccessKey       The shared access key.
*/
function ServiceBusSettings(serviceBusEndpointUri, wrapEndpointUri, namespace, wrapName, wrapPassword, sharedAccessKeyName, sharedAccessKey) {
  this._namespace = namespace;
  this._serviceBusEndpointUri = serviceBusEndpointUri;

  if (wrapEndpointUri) {
    this._wrapEndpointUri = wrapEndpointUri;
  } else {
    this._wrapEndpointUri = 'https://' + namespace + '-sb.accesscontrol.windows.net:443/WRAPv0.9';
  }

  this._wrapName = wrapName;
  this._wrapPassword = wrapPassword;
  this._sharedAccessKeyName = sharedAccessKeyName;
  this._sharedAccessKey = sharedAccessKey;
}

/**
* Creates a ServiceBusSettings object from a set of settings.
*
* @param {object} settings The settings object.
*
* @return {ServiceBusSettings}
*/
ServiceBusSettings.createFromSettings = function (settings) {
  if (settings.endpoint) {
    settings.endpoint = settings.endpoint.replace('sb://', 'https://');
  }

  var matchedSpecs;
  if (settings.sharedaccesskeyname) {
    matchedSpecs = ServiceSettings.matchedSpecification(
      settings,
      ServiceSettings.allRequired(
        serviceBusEndpointSetting,
        sharedAccessKeyNameSetting,
        sharedAccessKeySetting
      )
    );
  } else {
    matchedSpecs = ServiceSettings.matchedSpecification(
      settings,
      ServiceSettings.allRequired(
        serviceBusEndpointSetting,
        wrapNameSetting,
        wrapPasswordSetting
      ),
      ServiceSettings.optional(wrapEndpointSetting)
    );
  }

  if (matchedSpecs) {
    var endpoint = util.tryGetValueInsensitive(
      ConnectionStringKeys.SERVICE_BUS_ENDPOINT_NAME,
      settings
    );

    var wrapEndpoint = util.tryGetValueInsensitive(
      ConnectionStringKeys.WRAP_ENDPOINT_NAME,
      settings
    );

    // Parse the namespace part from the URI
    var parsedUrl = url.parse(endpoint);
    var namespace = parsedUrl.host.split('.')[0];

    var issuerName  = util.tryGetValueInsensitive(
      ConnectionStringKeys.SHARED_SECRET_ISSUER_NAME,
      settings
    );

    var issuerValue = util.tryGetValueInsensitive(
      ConnectionStringKeys.SHARED_SECRET_VALUE_NAME,
      settings
    );

    var sharedAccessKeyName = util.tryGetValueInsensitive(
      ConnectionStringKeys.SHARED_ACCESS_KEY_NAME,
      settings
    );

    var sharedAccessKey = util.tryGetValueInsensitive(
      ConnectionStringKeys.SHARED_ACCESS_KEY,
      settings
    );

    return new ServiceBusSettings(
      endpoint,
      wrapEndpoint,
      namespace,
      issuerName,
      issuerValue,
      sharedAccessKeyName,
      sharedAccessKey
    );
  }

  ServiceSettings.noMatchSettings(settings);
};

/**
* Creates a ServiceBusSettings object from the given connection string.
*
* @param {string} connectionString The storage settings connection string.
*
* @return {ServiceBusSettings}
*/
ServiceBusSettings.createFromConnectionString = function (connectionString) {
  var tokenizedSettings = ServiceSettings.parseAndValidateKeys(connectionString, validKeys);
  try {
    return ServiceBusSettings.createFromSettings(tokenizedSettings);
  } catch (e) {
    if (e instanceof ServiceSettings.NoMatchError) {
      // Replace no match settings exception by no match connection string one.
      ServiceSettings.noMatchConnectionString(connectionString);
    } else {
      throw e;
    }
  }
};

/*
* Code that deals with the sdk configuration object
*/

// Keys used to look up values in configuration
var configKeys = {
  CONNECTION_STRING: 'service bus connection string'
};

// Check if the old environment variables are set
function separateEnvironmentVariablesSet() {
  var varsToFind = [EnvironmentVariables.AZURE_SERVICEBUS_NAMESPACE,
    EnvironmentVariables.AZURE_SERVICEBUS_ACCESS_KEY];
  return varsToFind.every(function (v) { return !!process.env[v]; });
}

// Create settings from the environment variables
function createSettingsFromEnvironment() {
  var namespace = process.env[EnvironmentVariables.AZURE_SERVICEBUS_NAMESPACE];
  var hostname = namespace + '.' + ServiceClientConstants.CLOUD_SERVICEBUS_HOST;
  var issuer = process.env[EnvironmentVariables.AZURE_SERVICEBUS_ISSUER];
  if (!issuer) {
    issuer = ServiceClientConstants.DEFAULT_SERVICEBUS_ISSUER;
  }
  var accessKey = process.env[EnvironmentVariables.AZURE_SERVICEBUS_ACCESS_KEY];
  var acsNamespace = process.env[EnvironmentVariables.AZURE_SERVICEBUS_WRAP_NAMESPACE];
  if (!acsNamespace) {
    acsNamespace = namespace + ServiceClientConstants.DEFAULT_WRAP_NAMESPACE_SUFFIX;
  }
  var acshostname = acsNamespace + '.' + ServiceClientConstants.CLOUD_ACCESS_CONTROL_HOST;

  var endpoint = url.format({ protocol: 'https', port: 443, hostname: hostname });
  var stsendpoint = url.format({
    protocol: 'https',
    port: 443,
    hostname: acshostname,
    pathname: 'WRAPv0.9'
  });

  return {
    endpoint: endpoint,
    sharedsecretissuer: issuer,
    sharedsecretvalue: accessKey,
    stsendpoint: stsendpoint
  };
}


/**
* Create a ServiceBusSettings object from the given configuration
*
* @param {object} config the configuration object to use, if not given will
*                        use azure.config.default
*
* @return {ServiceBusSettings}
*/

ServiceBusSettings.createFromConfig = function (config) {
  if (!config) {
    config = azureCommon.config['default'];
  }

  var connectionString;

  if (config.has(configKeys.CONNECTION_STRING)) {
    connectionString = config.get(configKeys.CONNECTION_STRING);
  } else if (process.env[EnvironmentVariables.AZURE_SERVICEBUS_CONNECTION_STRING]) {
    connectionString = process.env[EnvironmentVariables.AZURE_SERVICEBUS_CONNECTION_STRING];
  } else if (separateEnvironmentVariablesSet()) {
    return ServiceBusSettings.createFromSettings(createSettingsFromEnvironment());
  }

  if (connectionString) {
    return ServiceBusSettings.createFromConnectionString(connectionString);
  }

  throw new Error('Cannot find correct Service Bus settings in configuration or environment');
};

/**
* Customize a config object with methods to configure service bus settings
*
* @param {config} config The configuration object to add to
*/
ServiceBusSettings.customizeConfig = function (config) {
  function serviceBus(connectionStringOrOptions) {
    if (_.isString(connectionStringOrOptions)) {
      this.set(configKeys.CONNECTION_STRING, connectionStringOrOptions);
    } else {
      var namespace = connectionStringOrOptions.namespace;
      var host = connectionStringOrOptions.host || ServiceClientConstants.CLOUD_SERVICEBUS_HOST;
      var stshost = connectionStringOrOptions.acsHost || ServiceClientConstants.CLOUD_ACCESS_CONTROL_HOST;
      var acsNamespace = connectionStringOrOptions.wrapNamespace ||
        namespace + ServiceClientConstants.DEFAULT_WRAP_NAMESPACE_SUFFIX;

      var hostname = namespace + '.' + host;
      var stshostname = acsNamespace + '.' + stshost;
      var issuer = connectionStringOrOptions.issuer || ServiceClientConstants.DEFAULT_SERVICEBUS_ISSUER;
      var key = connectionStringOrOptions.key;

      var parts = {
        Endpoint: 'sb://' + hostname + ':443',
        StsEndpoint: 'https://' + stshostname + ':443/WRAPv0.9',
        SharedSecretIssuer: issuer,
        SharedSecretValue: key
      };

      var connectionString = nodeutil.format('Endpoint=%s;StsEndpoint=%s;SharedSecretIssuer=%s;SharedSecretValue=%s',
        parts.Endpoint, parts.StsEndpoint, parts.SharedSecretIssuer, parts.SharedSecretValue);

      this.set(configKeys.CONNECTION_STRING, connectionString);
    }
  }

  config.serviceBus = serviceBus;
};

module.exports = ServiceBusSettings;
