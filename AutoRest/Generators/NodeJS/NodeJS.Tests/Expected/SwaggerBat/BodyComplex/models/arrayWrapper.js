'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ArrayWrapper class.
 * @constructor
 */
function ArrayWrapper() { }

/**
 * Validate the payload against the ArrayWrapper schema
 *
 * @param {JSON} payload
 *
 */
ArrayWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ArrayWrapper cannot be null.');
  }
  if (payload['array'] !== null && payload['array'] !== undefined && util.isArray(payload['array'])) {
    for (var i = 0; i < payload['array'].length; i++) {
      if (payload['array'][i] !== null && payload['array'][i] !== undefined && typeof payload['array'][i] !== 'string') {
        throw new Error('payload[\'array\'][i] must be of type string.');
      }
    }
  }
};

/**
 * Deserialize the instance to ArrayWrapper schema
 *
 * @param {JSON} instance
 *
 */
ArrayWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new ArrayWrapper();
