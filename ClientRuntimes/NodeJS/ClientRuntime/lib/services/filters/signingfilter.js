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

// Module dependencies.
var requestPipeline = require('../../http/request-pipeline');

/**
* Creates a filter to do the signing of a request.
* @param {object} authenticationProvider The authentication provider to use to sign the request.
*/
exports.create = function (authenticationProvider) {
  return function (resource, next, callback) {
    return requestPipeline.interimStream(function (inputStream, outputStream) {
      inputStream.pause();
      authenticationProvider.signRequest(resource, function (err) {
        if (err) {
          inputStream.resume();
          return callback(err);
        }

        var nextStream = next(resource, callback);
        resource.pipeInput(inputStream, nextStream).pipe(outputStream);
        inputStream.resume();
      });
    });
  };
};