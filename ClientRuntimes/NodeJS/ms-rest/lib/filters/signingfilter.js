// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

var requestPipeline = require('../requestPipeline');

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