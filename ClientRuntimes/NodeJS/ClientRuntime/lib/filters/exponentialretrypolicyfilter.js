// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var _ = require('underscore');
var utils = require('../utils');

/**
 * Determines if the operation should be retried and how long to wait until the next retry.
 *
 * @param {number} statusCode The HTTP status code.
 * @param {object} retryData  The retry data.
 * @return {bool} True if the operation qualifies for a retry; false otherwise.
 */
function shouldRetry(statusCode, retryData) {
  if ((statusCode < 500 && statusCode !== 408) || statusCode === 501 || statusCode === 505) {
    return false;
  }
  
  var currentCount;
  if (!retryData) {
    throw new Error('retryData for the ExponentialRetryPolicyFilter cannot be null.');
  } else {
    currentCount = (retryData && retryData.retryCount);
  }

  return (currentCount < this.retryCount);
}

/**
 * Updates the retry data for the next attempt.
 *
 * @param {object} retryData  The retry data.
 * @param {object} err        The operation's error, if any.
 */
function updateRetryData (retryData, err) {
  if (!retryData) {
    retryData = {
      retryCount: 0,
      error: null
    };
  }

  if (err) {
    if (retryData.error) {
      err.innerError = retryData.error;
    }

    retryData.error = err;
  }

  // Adjust retry count
  retryData.retryCount++;

  // Adjust retry interval
  var incrementDelta = Math.pow(2, retryData.retryCount) - 1;
  var boundedRandDelta = this.retryInterval * 0.8 + 
    Math.floor(Math.random() * (this.retryInterval * 1.2 - this.retryInterval * 0.8));
  incrementDelta *= boundedRandDelta;

  retryData.retryInterval = Math.min(this.minRetryInterval + incrementDelta, this.maxRetryInterval);

  return retryData;
}


/**
* Handles an operation with an exponential retry policy.
*
* @param {Object}   requestOptions The original request options.
* @param {function} next           The next filter to be handled.
* @return {undefined}
*/
function handle(requestOptions, next) {
  var self = this;
  var retryData = null;

  var operation = function () {
    // retry policies dont really do anything to the request options
    // so move on to next
    if (next) {
      next(requestOptions, function (returnObject, finalCallback, nextPostCallback) {
        // Previous operation ended so update the retry data
        retryData = self.updateRetryData(retryData, returnObject.error);

        if (returnObject.error &&
            ((!utils.objectIsNull(returnObject.response) &&
            self.shouldRetry(returnObject.response.statusCode, retryData)) ||
            returnObject.error.message === 'ETIMEDOUT' ||
            returnObject.error.message === 'ESOCKETTIMEDOUT')) {

          // If previous operation ended with an error and the policy allows a retry, do that
          setTimeout(function () {
            operation();
          }, retryData.retryInterval);
        } else {
          if (!utils.objectIsNull(returnObject.error)) {
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
* Creates a new 'ExponentialRetryPolicyFilter' instance.
*
* @constructor
* @param {number} retryCount        The client retry count.
* @param {number} retryInterval     The client retry interval, in milliseconds.
* @param {number} minRetryInterval  The minimum retry interval, in milliseconds.
* @param {number} maxRetryInterval  The maximum retry interval, in milliseconds.
*/
function ExponentialRetryPolicyFilter(retryCount, retryInterval, minRetryInterval, maxRetryInterval) {
  function newFilter(options, next, callback) {
    var retryData = null;

    function retryCallback(err, response, body) {
      retryData = newFilter.updateRetryData(retryData, err);
      if (!utils.objectIsNull(response) && newFilter.shouldRetry(response.statusCode, retryData)) {

        // If previous operation ended with an error and the policy allows a retry, do that
        setTimeout(function () {
          next(options, retryCallback);
        }, retryData.retryInterval);
      } else {
        if (!utils.objectIsNull(err)) {
          // If the operation failed in the end, return all errors instead of just the last one
          err = retryData.error;
        }
        callback(err, response, body);
      }
    }

    return next(options, retryCallback);
  }

  _.extend(newFilter, {
    retryCount: isNaN(retryCount) ? ExponentialRetryPolicyFilter.DEFAULT_CLIENT_RETRY_COUNT : retryCount,
    retryInterval: isNaN(retryInterval) ? ExponentialRetryPolicyFilter.DEFAULT_CLIENT_RETRY_INTERVAL : retryInterval,
    minRetryInterval: isNaN(minRetryInterval) ? ExponentialRetryPolicyFilter.DEFAULT_CLIENT_MIN_RETRY_INTERVAL : minRetryInterval,
    maxRetryInterval: isNaN(maxRetryInterval) ? ExponentialRetryPolicyFilter.DEFAULT_CLIENT_MAX_RETRY_INTERVAL : maxRetryInterval,
    handle: handle,
    shouldRetry: shouldRetry,
    updateRetryData: updateRetryData
  });

  return newFilter;


}

/**
* Represents the default client retry interval, in milliseconds.
*/
ExponentialRetryPolicyFilter.DEFAULT_CLIENT_RETRY_INTERVAL = 1000 * 30;

/**
* Represents the default client retry count.
*/
ExponentialRetryPolicyFilter.DEFAULT_CLIENT_RETRY_COUNT = 3;

/**
* Represents the default maximum retry interval, in milliseconds.
*/
ExponentialRetryPolicyFilter.DEFAULT_CLIENT_MAX_RETRY_INTERVAL = 1000 * 90;

/**
* Represents the default minimum retry interval, in milliseconds.
*/
ExponentialRetryPolicyFilter.DEFAULT_CLIENT_MIN_RETRY_INTERVAL = 1000 * 3;

module.exports = ExponentialRetryPolicyFilter;