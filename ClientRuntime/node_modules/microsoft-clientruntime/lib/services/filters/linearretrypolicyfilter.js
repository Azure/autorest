/**
* Copyright (c) Microsoft.  All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*   http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

var _ = require('underscore');
var azureutil = require('../../util/util');

/**
* Determines if the operation should be retried and how long to wait until the next retry.
*
 * @param {number} statusCode The HTTP status code.
 * @param {object} retryData  The retry data.
 * @return {bool} True if the operation qualifies for a retry; false otherwise.
*/
function shouldRetry(statusCode, retryData) {
  // Retry on HTTP TimeOut 408
  if (statusCode < 500 && statusCode != 408) {
    return false;
  }

  var currentCount = (retryData && retryData.retryCount) ? retryData.retryCount : 0;

  return (currentCount < this.retryCount);
}

/**
* Updates the retry data for the next attempt.
*
* @param {object} retryData  The retry data.
* @param {object} err        The operation's error, if any.
* @return {undefined}
*/
function updateRetryData(retryData, err) {
  if (!retryData) {
    retryData = {
      retryCount: 0,
      retryInterval: this.retryInterval,
      error: null
    };
  }

  if (err) {
    if (retryData.error) {
      err.innerError = retryData.error;
    }

    retryData.error = err;
  }

  retryData.retryCount++;
  return retryData;
}

/**
* Handles an operation with a linear retry policy.
*
* @param {Object}   requestOptions The original request options.
* @param {function} next           The next filter to be handled.
* @return {undefined}
*/
function handle(requestOptions, next) {
  var retryData = null;
  var self = this;

  var operation = function () {
    // retry policies dont really do anything to the request options
    // so move on to next
    if (next) {
      next(requestOptions, function (returnObject, finalCallback, nextPostCallback) {
        // Previous operation ended so update the retry data
        retryData = self.updateRetryData(retryData, returnObject.error);

        if (returnObject.error &&
            ((!azureutil.objectIsNull(returnObject.response) &&
            self.shouldRetry(returnObject.response.statusCode, retryData)) ||
            returnObject.error.message === 'ETIMEDOUT' ||
            returnObject.error.message === 'ESOCKETTIMEDOUT')) {

          // If previous operation ended with an error and the policy allows a retry, do that
          setTimeout(function () {
            operation();
          }, retryData.retryInterval);
        } else {
          if (!azureutil.objectIsNull(returnObject.error)) {
            // If the operation failed in the end, return all errors instead of just the last one
            returnObject.error = retryData.error;
          }

          if (nextPostCallback) {
            nextPostCallback(returnObject);
          } else if (finalCallback) {
            finalCallback(returnObject);
          }
        }
      });
    }
  };

  operation();
}

/**
* Creates a new LinearRetryPolicyFilter instance.
*
* @constructor
* @param {number} retryCount        The client retry count.
* @param {number} retryInterval     The client retry interval, in milliseconds.
*/
function LinearRetryPolicyFilter(retryCount, retryInterval) {
  // Implement the new style filter in terms of the old implementation
  function newFilter(options, next, callback) {
    var retryData = null;

    function retryCallback(err, result, response, body) {
      retryData = newFilter.updateRetryData(retryData, err);
      if (err &&
        ((!azureutil.objectIsNull(response) &&
        newFilter.shouldRetry(response.statusCode, retryData)) ||
        err.message === 'ETIMEDOUT' ||
        err.message === 'ESOCKETTIMEDOUT')) {

        // If previous operation ended with an error and the policy allows a retry, do that
        setTimeout(function () {
          next(options, retryCallback);
        }, retryData.retryInterval);
      } else {
        if (!azureutil.objectIsNull(err)) {
          // If the operation failed in the end, return all errors instead of just the last one
          err = retryData.error;
        }
        callback(err, result, response, body);
      }
    }

    return next(options, retryCallback);
  }

  _.extend(newFilter, {
    retryCount: retryCount || LinearRetryPolicyFilter.DEFAULT_CLIENT_RETRY_COUNT,
    retryInterval: retryInterval || LinearRetryPolicyFilter.DEFAULT_CLIENT_RETRY_INTERVAL,
    handle: handle,
    shouldRetry: shouldRetry,
    updateRetryData: updateRetryData
  });

  return newFilter;
}

/**
* Represents the default client retry interval, in milliseconds.
*/
LinearRetryPolicyFilter.DEFAULT_CLIENT_RETRY_INTERVAL = 1000 * 30;

/**
* Represents the default client retry count.
*/
LinearRetryPolicyFilter.DEFAULT_CLIENT_RETRY_COUNT = 3;

module.exports = LinearRetryPolicyFilter;