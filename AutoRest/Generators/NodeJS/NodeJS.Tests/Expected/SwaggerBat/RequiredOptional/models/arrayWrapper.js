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
  if (payload['value'] === null || payload['value'] === undefined) {
    throw new Error('payload[\'value\'] cannot be null or undefined.');
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
 * Deserialize the instance to ArrayWrapper schema
 *
 * @param {JSON} instance
 *
 */
ArrayWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new ArrayWrapper();
