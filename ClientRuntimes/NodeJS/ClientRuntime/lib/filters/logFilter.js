// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var util = require('util');

var dump = util.inspect;

/**
 * logFilter = simple filter to do logging on requests and responses
 */
exports.create = function (logger) {
  var log = logger ? logger.log : console.log;
  return function handle (options, next, callback) {
    log('logFilter, request: %s', dump(options));
    return next(options, function (err, response, body) {
      if (err) {
        log('Error from response, message: ' + err.message);
        return callback(err);
      }

      log('Response status code: ' + response.statusCode);
      log('Body: ' + body);
      return callback(err, response, body);
    });
  };
};