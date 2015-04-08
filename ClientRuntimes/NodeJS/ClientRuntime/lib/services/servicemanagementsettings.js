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
var fs = require('fs');
var url = require('url');
var util = require('../util/util');
var certutils = require('../util/certutils');

var azure = require('../common');
var ServiceSettings = require('./servicesettings');
var Constants = require('../util/constants');
var ServiceClientConstants = require('./serviceclientconstants');
var ConnectionStringKeys = Constants.ConnectionStringKeys;
var Validate = require('../util/validate');

var endpointSetting = ServiceSettings.settingWithFunc(
  ConnectionStringKeys.SERVICE_MANAGEMENT_ENDPOINT_NAME,
  Validate.isValidUri
);

var certificatePathSetting = ServiceSettings.setting(ConnectionStringKeys.CERTIFICATE_PATH_NAME);
var subscriptionIdSetting = ServiceSettings.setting(ConnectionStringKeys.SUBSCRIPTION_ID_NAME);

var validKeys = [
  ConnectionStringKeys.SUBSCRIPTION_ID_NAME,
  ConnectionStringKeys.CERTIFICATE_PATH_NAME,
  ConnectionStringKeys.SERVICE_MANAGEMENT_ENDPOINT_NAME
];

/**
* Creates new service management settings instance.
*
* @param {string} subscriptionId  The user provided subscription id.
* @param {string} endpointUri     The service management endpoint uri.
* @param {string} certificatePath The management certificate path.
*/
function ServiceManagementSettings(subscriptionId, endpointUri, certificatePath, cert, key) {
  this._subscriptionId = subscriptionId;
  this._endpointUri = endpointUri;
  this._certificatePath = certificatePath;
  this._certificate = cert;
  this._key = key;
}

/**
* Creates a ServiceBusSettings object from a set of settings.
*
* @param {object} settings The settings object.
*
* @return {ServiceManagementSettings}
*/
ServiceManagementSettings.createFromSettings = function (settings) {
  var matchedSpecs = ServiceSettings.matchedSpecification(
    settings,
    ServiceSettings.allRequired(
      subscriptionIdSetting,
      certificatePathSetting
    ),
    ServiceSettings.optional(
      endpointSetting
    )
  );

  if (matchedSpecs) {
    var endpointUri = util.tryGetValueInsensitive(
      ConnectionStringKeys.SERVICE_MANAGEMENT_ENDPOINT_NAME,
      settings,
      Constants.SERVICE_MANAGEMENT_URL
    );

    var subscriptionId = util.tryGetValueInsensitive(
      ConnectionStringKeys.SUBSCRIPTION_ID_NAME,
      settings
    );

    var certificatePath = util.tryGetValueInsensitive(
      ConnectionStringKeys.CERTIFICATE_PATH_NAME,
      settings
    );

    return new ServiceManagementSettings(
      subscriptionId,
      endpointUri,
      certificatePath
    );
  }

  ServiceSettings.noMatchSettings(settings);
};

/**
* Creates a ServiceManagementSettings object from the given connection string.
*
* @param {string} connectionString The storage settings connection string.
*
* @return {ServiceManagementSettings}
*/
ServiceManagementSettings.createFromConnectionString = function (connectionString) {
  var tokenizedSettings = ServiceSettings.parseAndValidateKeys(connectionString, validKeys);
  try {
    return ServiceManagementSettings.createFromSettings(tokenizedSettings);
  } catch (e) {
    if (e instanceof ServiceSettings.NoMatchError) {
      // Replace no match settings exception by no match connection string one.
      ServiceSettings.noMatchConnectionString(connectionString);
    } else {
      throw e;
    }
  }
};

/**
* Creates a new configuration object based on the
* parameters passed. Used to set up service management
* objects with the original parameter sets.
*
* @param {string} subscriptionId the subscription id
*
* @param {object} auth authentication information
*
* @param {string} [auth.keyvalue] Value for certificate key. Use this or keyfile, not both.
* @param {string} [auth.keyfile] File path for certificate key. Use this or keyvalue, not both.
* @param {string} [auth.certvalue] Value for certificate. Use this or certfile, not both.
* @param {string} [auth.cerfile] File path for certificate. Use this or certvalue, not both.
*
* @param {object} hostOptions Options for the connection
* @param {string} [hostOptions.host] Hostname for the service management service to use
* @param {number} [hostOptions.port] Port number to connect to service management service
*
* @return {envConf.Config} the configuration
*/
ServiceManagementSettings.configFromParameters = function configFromParameters(subscriptionId, auth, hostOptions) {
  auth = auth || {};
  hostOptions = hostOptions || {};

  var c = azure.config.default.tempConfig();
  c.subscriptionId(subscriptionId);

  if (auth.keyvalue && auth.keyfile) {
    throw new Error('Authorization should specify keyvalue or keyfile, but not both');
  }
  if (auth.keyvalue) {
    c.serviceManagementKey(auth.keyvalue);
  } else if (auth.keyfile) {
    c.serviceManagementKeyFile(auth.keyfile);
  }

  if (auth.certvalue && auth.certfile) {
    throw new Error('Authorization should specify certvalue or certfile, but not both');
  }
  if (auth.certvalue) {
    c.serviceManagementCert(auth.certvalue);
  } else if (auth.certfile) {
    c.serviceManagementCertFile(auth.certfile);
  }

  var host = hostOptions.host || ServiceClientConstants.CLOUD_SERVICE_MANAGEMENT_HOST;
  var port = hostOptions.port || null;
  c.serviceManagementHostUri(url.format({
    protocol: Constants.HTTPS,
    hostname: host,
    port: port
  }));

  return c;
};

ServiceManagementSettings.createFromParameters = function (configOrSubscriptionId, auth, hostOptions) {
  var config = configOrSubscriptionId;
  if (!config) {
    config = azure.config.default;
  } else if (typeof config !== 'function') {
    config = ServiceManagementSettings.configFromParameters(configOrSubscriptionId, auth, hostOptions);
  }

  return ServiceManagementSettings.createFromConfig(config);
};

// Helper function for reading certificate files
function readFileContents(path, filePurpose) {
  try {
    return fs.readFileSync(path, 'ascii');
  } catch (ex) {
    throw new Error('The ' + filePurpose + ' file at ' + path + ' could not be read: ' + ex.message);
  }
}

//
// Keys used to look up values from SDK configuration
//
var configKeys = {
  SUBSCRIPTION_ID: 'service management subscription id',
  KEY: 'service management certificate key value',
  CERT: 'service management certificate value',
  HOST_URI: 'service management host uri'
};

ServiceManagementSettings.createFromConfig = function (config) {
  return new ServiceManagementSettings(
    config.get(configKeys.SUBSCRIPTION_ID),
    config.get(configKeys.HOST_URI),
    null,
    config.get(configKeys.CERT),
    config.get(configKeys.KEY));
};

function readPemFile(fileName) {
  var auth = certutils.readPemFile(fileName);

  if (auth.key) {
    this.set(configKeys.KEY, auth.key);
  }

  if (auth.cert) {
    this.set(configKeys.CERT, auth.cert);
  }
}

function getCertPart(envVar, purpose) {
  return function () {
    if (!process.env[ServiceClientConstants.EnvironmentVariables[envVar]]) {
      throw new Error('No ' + purpose + ' or ' + purpose + ' file found in configuration');
    }
    return readFileContents(process.env[ServiceClientConstants.EnvironmentVariables[envVar]], purpose);
  };
}

ServiceManagementSettings.customizeConfig = function (config) {
  function setValue(key) {
    return function (value) {
      config.set(configKeys[key], value);
      return config;
    };
  }

  _.extend(config, {
    subscriptionId: setValue('SUBSCRIPTION_ID'),
    serviceManagementCert: setValue('CERT'),
    serviceManagementKey: setValue('KEY'),
    serviceManagementHostUri: setValue('HOST_URI'),

    serviceManagementCertFile: function (certFilePath) {
      this.set(configKeys.CERT, readFileContents(certFilePath, 'certificate'));
      return this;
    },

    serviceManagementKeyFile: function (keyFilePath) {
      this.set(configKeys.KEY, readFileContents(keyFilePath, 'certificate key'));
      return this;
    },

    serviceManagementPemFile: readPemFile
  });
};

ServiceManagementSettings.setDefaultConfig = function (config) {
  config.set(configKeys.HOST_URI, Constants.SERVICE_MANAGEMENT_URL);
  config.setFunc(configKeys.CERT, getCertPart('AZURE_CERTFILE', 'certificate'));
  config.setFunc(configKeys.KEY, getCertPart('AZURE_KEYFILE', 'certificate key'));
};

module.exports = ServiceManagementSettings;