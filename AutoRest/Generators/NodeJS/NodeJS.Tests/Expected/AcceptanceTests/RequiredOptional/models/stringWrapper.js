'use strict';

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
  if (payload['value'] === null || payload['value'] === undefined || typeof payload['value'].valueOf() !== 'string') {
    throw new Error('payload[\'value\'] cannot be null or undefined and it must be of type string.');
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
