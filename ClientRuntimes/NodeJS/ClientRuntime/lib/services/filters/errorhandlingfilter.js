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

var Constants = require('../../util/constants');
var HttpResponseCodes = Constants.HttpConstants.HttpResponseCodes;

/**
* Creates a filter to handle an error response. This includes parsing and normalizing error responses.
*/
exports.create = function() {
  var ServiceClient = require('../serviceclient');

  return function handle (resource, next, callback) {
    var nextStream = next(resource, function (err, response, body) {
      if (!err && !(response.statusCode >= 200 && response.statusCode < 300)) {
        var rsp = ServiceClient._parseResponse(ServiceClient._buildResponse(false, body, response.headers, response.statusCode, null), ServiceClient._getDefaultXml2jsSettings());

        var errorBody = rsp.body;
        if (!errorBody) {
          var code = Object.keys(HttpResponseCodes).filter(function (name) {
            if (HttpResponseCodes[name] === rsp.statusCode) {
              return name;
            }
          });

          errorBody = { error: { code: code[0] } };
        }

        err = ServiceClient._normalizeError(errorBody, response);

        nextStream.emit('error', err);
      }

      callback(err, response, body);
    });

    nextStream.on('error', function () {});
    return nextStream;
  };
};
