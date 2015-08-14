'use strict';

/**
 * @class
 * Initializes a new instance of the LongWrapper class.
 * @constructor
 */
function LongWrapper() { }

/**
 * Validate the payload against the LongWrapper schema
 *
 * @param {JSON} payload
 *
 */
LongWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('LongWrapper cannot be null.');
  }
  if (payload['field1'] !== null && payload['field1'] !== undefined && typeof payload['field1'] !== 'number') {
    throw new Error('payload[\'field1\'] must be of type number.');
  }

  if (payload['field2'] !== null && payload['field2'] !== undefined && typeof payload['field2'] !== 'number') {
    throw new Error('payload[\'field2\'] must be of type number.');
  }
};

/**
 * Deserialize the instance to LongWrapper schema
 *
 * @param {JSON} instance
 *
 */
LongWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new LongWrapper();
