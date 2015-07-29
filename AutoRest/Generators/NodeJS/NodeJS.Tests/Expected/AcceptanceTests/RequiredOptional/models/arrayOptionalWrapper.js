'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ArrayOptionalWrapper class.
 * @constructor
 */
function ArrayOptionalWrapper() { }

/**
 * Validate the payload against the ArrayOptionalWrapper schema
 *
 * @param {JSON} payload
 *
 */
ArrayOptionalWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ArrayOptionalWrapper cannot be null.');
  }
  if (payload['value'] !== null && payload['value'] !== undefined && util.isArray(payload['value'])) {
    for (var i = 0; i < payload['value'].length; i++) {
      if (payload['value'][i] !== null && payload['value'][i] !== undefined && typeof payload['value'][i] !== 'string') {
        throw new Error('payload[\'value\'][i] must be of type string.');
      }
    }
  }
};

/**
 * Deserialize the instance to ArrayOptionalWrapper schema
 *
 * @param {JSON} instance
 *
 */
ArrayOptionalWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new ArrayOptionalWrapper();
