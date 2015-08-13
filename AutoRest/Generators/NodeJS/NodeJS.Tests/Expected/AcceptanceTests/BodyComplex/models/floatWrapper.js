'use strict';

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the FloatWrapper class.
 * @constructor
 */
function FloatWrapper() { }

/**
 * Validate the payload against the FloatWrapper schema
 *
 * @param {JSON} payload
 *
 */
FloatWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('FloatWrapper cannot be null.');
  }
  if (payload['field1'] !== null && payload['field1'] !== undefined && typeof payload['field1'] !== 'number') {
    throw new Error('payload[\'field1\'] must be of type number.');
  }

  if (payload['field2'] !== null && payload['field2'] !== undefined && typeof payload['field2'] !== 'number') {
    throw new Error('payload[\'field2\'] must be of type number.');
  }
};

/**
 * Deserialize the instance to FloatWrapper schema
 *
 * @param {JSON} instance
 *
 */
FloatWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new FloatWrapper();
