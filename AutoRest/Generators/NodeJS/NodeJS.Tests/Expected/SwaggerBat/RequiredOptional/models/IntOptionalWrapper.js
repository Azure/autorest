'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the IntOptionalWrapper class.
 * @constructor
 */
function IntOptionalWrapper() { }

/**
 * Validate the payload against the IntOptionalWrapper schema
 *
 * @param {JSON} payload
 *
 */
IntOptionalWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('IntOptionalWrapper cannot be null.');
  }
  if (payload['value'] !== null && payload['value'] !== undefined && typeof payload['value'] !== 'number') {
    throw new Error('payload["value"] must be of type number.');
  }

};

/**
 * Deserialize the instance to IntOptionalWrapper schema
 *
 * @param {JSON} instance
 *
 */
IntOptionalWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new IntOptionalWrapper();
