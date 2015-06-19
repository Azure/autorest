// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var url = require('url');
/**
* Creates a filter that handles server redirects for Http Statuscode 307.
*/
exports.create = function (maximumRetries) {
  return function handle (resource, next, callback) {
    var currentRetries = 0;

    function handleRedirect(err, response, body) {
      if (response && response.headers &&
          response.headers.location &&
          (response.statusCode === 307 || 
            (response.statusCode === 303 && resource.method === 'POST')) && 
          (!maximumRetries ||
          currentRetries < maximumRetries)) {
        currentRetries++;
        
        if (url.parse(response.headers.location).hostname) {
          resource.url = response.headers.location;
        } else {
          var urlObject = url.parse(resource.url);
          urlObject.pathname = response.headers.location;
          resource.url = url.format(urlObject);
        }
        // POST request with Status code 303 should be converted into a 
        // redirected GET request if the redirect url is present in the location header
        if (response.statusCode === 303) {
          resource.method = 'GET';
        }

        next(resource, handleRedirect);
      } else if (callback) {
        callback(err, response, body);
      }
    }

    return next(resource, handleRedirect);
  };
};