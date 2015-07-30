'use strict';

var util = require('util');

var models = require('./index');

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
  if (payload['value'] === null || payload['value'] === undefined || typeof payload['value'] !== 'number') {
    throw new Error('payload[\'value\'] cannot be null or undefined and it must be of type number.');
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
