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

var validate = require('../../util/validate');
var keyFiles = require('../../util/keyFiles');

/**
* Creates a new CertificateCloudCredentials object.
* Either a pair of cert / key values need to be pass or a pem file location.
*
* @constructor
* @param {string} credentials.subscription  The subscription identifier.
* @param {string} [credentials.cert]        The certificate.
* @param {string} [credentials.key]         The certificate key.
* @param {string} [credentials.pem]         The PEM file content.
*/
function CertificateCloudCredentials(credentials) {
  if (credentials.pem) {
    if (typeof(credentials.pem) !== 'string') {
      credentials.pem = credentials.pem.toString();
    }
    validate.validateArgs('CertificateCloudCredentials', function (v) {
      v.object(credentials, 'credentials');
      v.string(credentials.subscriptionId, 'credentials.subscriptionId');
      v.string(credentials.pem, 'credentials.pem');
    });

    var cred = keyFiles.read(credentials.pem);
    credentials.cert = cred.cert;
    credentials.key = cred.key;
  } else {
    validate.validateArgs('CertificateCloudCredentials', function (v) {
      v.object(credentials, 'credentials');
      v.string(credentials.subscriptionId, 'credentials.subscriptionId');
      v.string(credentials.cert, 'credentials.cert');
      v.string(credentials.key, 'credentials.key');
    });
  }

  this.subscriptionId = credentials.subscriptionId;
  this.credentials = credentials;
}

/**
* Signs a request with the Authentication header.
*
* @param {WebResource} The webresource to be signed.
* @param {function(error)}  callback  The callback function.
* @return {undefined}
*/
CertificateCloudCredentials.prototype.signRequest = function (webResource, callback) {
  webResource.cert = this.credentials.cert;
  webResource.key = this.credentials.key;
  callback(null);
};

module.exports = CertificateCloudCredentials;