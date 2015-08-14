'use strict';

/**
 * @class
 * Initializes a new instance of the IntWrapper class.
 * @constructor
 */
function IntWrapper() { }

/**
 * Validate the payload against the IntWrapper schema
 *
 * @param {JSON} payload
 *
 */
IntWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('IntWrapper cannot be null.');
  }
  if (payload['field1'] !== null && payload['field1'] !== undefined && typeof payload['field1'] !== 'number') {
    throw new Error('payload[\'field1\'] must be of type number.');
  }

  if (payload['field2'] !== null && payload['field2'] !== undefined && typeof payload['field2'] !== 'number') {
    throw new Error('payload[\'field2\'] must be of type number.');
  }
};

/**
 * Deserialize the instance to IntWrapper schema
 *
 * @param {JSON} instance
 *
 */
IntWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new IntWrapper();
