'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ByteWrapper class.
 * @constructor
 */
function ByteWrapper() { }

/**
 * Validate the payload against the ByteWrapper schema
 *
 * @param {JSON} payload
 *
 */
ByteWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ByteWrapper cannot be null.');
  }
  if (payload['field'] && !Buffer.isBuffer(payload['field'])) {
    throw new Error('payload[\'field\'] must be of type buffer.');
  }
};

/**
 * Deserialize the instance to ByteWrapper schema
 *
 * @param {JSON} instance
 *
 */
ByteWrapper.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.field !== null && instance.field !== undefined && typeof instance.field.valueOf() === 'string') {
      instance.field = new Buffer(instance.field, 'base64');
    }
  }
  return instance;
};

module.exports = new ByteWrapper();
