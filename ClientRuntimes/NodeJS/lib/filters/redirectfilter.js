// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

/**
* Creates a that handles server redirects;
*/
exports.create = function (maximumRetries) {
  return function handle (resource, next, callback) {
    var currentRetries = 0;

    function handleRedirect(err, response, body) {
      if (response && response.headers &&
          response.headers.location &&
          response.statusCode >= 300 &&
          response.statusCode < 400 &&
          (!maximumRetries ||
          currentRetries < maximumRetries)) {
        currentRetries++;

        resource.url = response.headers.location;
        next(resource, handleRedirect);
      } else if (callback) {
        callback(err, response, body);
      }
    }

    return next(resource, handleRedirect);
  };
};