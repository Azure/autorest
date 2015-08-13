'use strict';

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
  if (!util.isArray(payload['value'])) {
    throw new Error('payload[\'value\'] cannot be null or undefined and it must be of type array.');
  }
  for (var i = 0; i < payload['value'].length; i++) {
    if (payload['value'][i] !== null && payload['value'][i] !== undefined && typeof payload['value'][i].valueOf() !== 'string') {
      throw new Error('payload[\'value\'][i] must be of type string.');
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
