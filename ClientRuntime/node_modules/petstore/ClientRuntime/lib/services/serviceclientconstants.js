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
var Constants = require('../util/constants');

var storageDnsSuffix = process.env.AZURE_STORAGE_DNS_SUFFIX || 'core.windows.net';

_.extend(exports, {
  /**
  * The default protocol.
  */
  DEFAULT_PROTOCOL: Constants.HTTPS,

  /*
  * Used environment variables.
  * @enum {string}
  */
  EnvironmentVariables: {
    AZURE_STORAGE_ACCOUNT: 'AZURE_STORAGE_ACCOUNT',
    AZURE_STORAGE_ACCESS_KEY: 'AZURE_STORAGE_ACCESS_KEY',
    AZURE_STORAGE_DNS_SUFFIX: 'AZURE_STORAGE_DNS_SUFFIX',
    AZURE_STORAGE_CONNECTION_STRING: 'AZURE_STORAGE_CONNECTION_STRING',
    AZURE_SERVICEBUS_CONNECTION_STRING: 'AZURE_SERVICEBUS_CONNECTION_STRING',
    AZURE_SERVICEBUS_NAMESPACE: 'AZURE_SERVICEBUS_NAMESPACE',
    AZURE_SERVICEBUS_ISSUER: 'AZURE_SERVICEBUS_ISSUER',
    AZURE_SERVICEBUS_ACCESS_KEY: 'AZURE_SERVICEBUS_ACCESS_KEY',
    AZURE_WRAP_NAMESPACE: 'AZURE_WRAP_NAMESPACE',
    HTTP_PROXY: 'HTTP_PROXY',
    HTTPS_PROXY: 'HTTPS_PROXY',
    EMULATED: 'EMULATED',
    AZURE_CERTFILE: 'AZURE_CERTFILE',
    AZURE_KEYFILE: 'AZURE_KEYFILE'
  },

  /**
  * Default credentials.
  */
  DEVSTORE_STORAGE_ACCOUNT: Constants.DEV_STORE_NAME,
  DEVSTORE_STORAGE_ACCESS_KEY: Constants.DEV_STORE_KEY,

  /**
  * Development ServiceClient URLs.
  */
  DEVSTORE_DEFAULT_PROTOCOL: 'http://',
  DEVSTORE_BLOB_HOST: Constants.DEV_STORE_BLOB_HOST,
  DEVSTORE_QUEUE_HOST: Constants.DEV_STORE_QUEUE_HOST,
  DEVSTORE_TABLE_HOST: Constants.DEV_STORE_TABLE_HOST,

  /**
  * Live ServiceClient URLs.
  */

  CLOUD_BLOB_HOST: 'blob.' + storageDnsSuffix,
  CLOUD_QUEUE_HOST: 'queue.' + storageDnsSuffix,
  CLOUD_TABLE_HOST: 'table.' + storageDnsSuffix,
  CLOUD_SERVICEBUS_HOST: 'servicebus.windows.net',
  CLOUD_ACCESS_CONTROL_HOST: 'accesscontrol.windows.net',
  CLOUD_SERVICE_MANAGEMENT_HOST: 'management.core.windows.net',
  CLOUD_DATABASE_HOST: 'database.windows.net',

  /**
  * The default service bus issuer.
  */
  DEFAULT_SERVICEBUS_ISSUER: 'owner',

  /**
  * The default wrap namespace suffix.
  */
  DEFAULT_WRAP_NAMESPACE_SUFFIX: '-sb'
});
