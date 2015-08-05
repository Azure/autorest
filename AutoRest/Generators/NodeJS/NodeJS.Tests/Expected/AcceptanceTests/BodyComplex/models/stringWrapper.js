'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the StringWrapper class.
 * @constructor
 */
function StringWrapper() { }

/**
 * Validate the payload against the StringWrapper schema
 *
 * @param {JSON} payload
 *
 */
StringWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('StringWrapper cannot be null.');
  }
  if (payload['field'] !== null && payload['field'] !== undefined && typeof payload['field'].valueOf() !== 'string') {
    throw new Error('payload[\'field\'] must be of type string.');
  }

  if (payload['empty'] !== null && payload['empty'] !== undefined && typeof payload['empty'].valueOf() !== 'string') {
    throw new Error('payload[\'empty\'] must be of type string.');
  }

  if (payload['null'] !== null && payload['null'] !== undefined && typeof payload['null'].valueOf() !== 'string') {
    throw new Error('payload[\'null\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to StringWrapper schema
 *
 * @param {JSON} instance
 *
 */
StringWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new StringWrapper();
