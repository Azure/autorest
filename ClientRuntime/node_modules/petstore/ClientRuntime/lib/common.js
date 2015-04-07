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

var exports = module.exports;

var azureutil = require('./util/util');

require('./util/patch-xmlbuilder');

var nodeVersion = azureutil.getNodeVersion();
if (nodeVersion.major === 0 && nodeVersion.minor > 8 && !(nodeVersion.minor > 10 || (nodeVersion.minor === 10 && nodeVersion.patch >= 3))) {
  throw new Error('The Microsoft Azure node SDK does not work with node versions > 0.8.22 and < 0.10.3. Please upgrade to node >= 0.10.3');
}

exports.xmlbuilder = require('xmlbuilder');
exports.xml2js = require('xml2js');

exports.Constants = require('./util/constants');
exports.Logger = require('./diagnostics/logger');
exports.date = require('./util/date');

exports.WebResource = require('./http/webresource');
exports.js2xml = require('./util/js2xml');
exports.Service = require('./services/service');
exports.ServiceClient = require('./services/serviceclient');
exports.StorageServiceClient = require('./services/storageserviceclient');
exports.ServiceManagementClient = require('./services/servicemanagementclient');

exports.ServiceSettings = require('./services/servicesettings');
exports.ServiceBusSettings = require('./services/servicebussettings');
exports.StorageServiceSettings = require('./services/storageservicesettings');
exports.ServiceManagementSettings = require('./services/servicemanagementsettings');
exports.ServiceClientConstants = require('./services/serviceclientconstants');

exports.ConnectionStringParser = require('./services/connectionstringparser');

// Credentials
exports.CertificateCloudCredentials = require('./services/credentials/certificateCloudCredentials');
exports.TokenCloudCredentials = require('./services/credentials/tokenCloudCredentials');
exports.AnonymousCloudCredentials = require('./services/credentials/anonymousCloudCredentials');

// Other filters
exports.LinearRetryPolicyFilter = require('./services/filters/linearretrypolicyfilter');
exports.ExponentialRetryPolicyFilter = require('./services/filters/exponentialretrypolicyfilter');
exports.UserAgentFilter = require('./services/filters/useragentfilter');
exports.ProxyFilter = require('./services/filters/proxyfilter');
exports.LogFilter = require('./services/filters/logfilter');
exports.ErrorHandlingFilter = require('./services/filters/errorhandlingfilter');
exports.SigningFilter = require('./services/filters/signingfilter');

exports.SdkConfig = require('./util/sdkconfig');
exports.config = exports.SdkConfig;

exports.configure = function (env, configCallback) {
  if (arguments.length === 1) {
    exports.config.configure(env);
  } else {
    exports.config.configure(env, configCallback);
  }
};

exports.dumpConfig = function () {
  console.log();
  exports.config.environments.forEach(function (e) {
    console.log('Environment', e);
    var env = exports.config(e);
    env.settings.forEach(function (setting) {
      console.log('    ', setting, ':', env.get(setting));
    });
  });
};


exports.HmacSha256Sign = require('./services/hmacsha256sign');
exports.ISO8061Date = require('./util/iso8061date');
exports.RFC1123 = require('./util/rfc1123date');

// pem files
exports.certutils = require('./util/certutils');
exports.keyFiles = require('./util/keyFiles');

exports.util = require('./util/util');
exports.validate = require('./util/validate');
exports.requestPipeline = require('./http/request-pipeline');
exports.OdataHandler = require('./util/odatahandler');
exports.atomHandler = require('./util/atomhandler');
exports.edmType = require('./util/edmtype');

exports.OperationStatus = require('./services/operationstatus');
