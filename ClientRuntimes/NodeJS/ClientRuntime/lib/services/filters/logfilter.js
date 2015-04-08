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

var util = require('util');
var dump = util.inspect;

/**
 * logFilter = simple filter to do logging on requests and responses
 */
exports.create = function () {
  return function handle (options, next, callback) {
    console.log('logFilter, request: %s', dump(options));
    return next(options, function (err, response, body) {
      if (err) {
        console.log('Error from response, message: ' + err.message);
        return callback(err);
      }

      console.log('Response status code: ' + response.statusCode);
      console.log('Body: ' + body);
      return callback(err, response, body);
    });
  };
};