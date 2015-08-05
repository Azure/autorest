'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the StringOptionalWrapper class.
 * @constructor
 */
function StringOptionalWrapper() { }

/**
 * Validate the payload against the StringOptionalWrapper schema
 *
 * @param {JSON} payload
 *
 */
StringOptionalWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('StringOptionalWrapper cannot be null.');
  }
  if (payload['value'] !== null && payload['value'] !== undefined && typeof payload['value'].valueOf() !== 'string') {
    throw new Error('payload[\'value\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to StringOptionalWrapper schema
 *
 * @param {JSON} instance
 *
 */
StringOptionalWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new StringOptionalWrapper();
