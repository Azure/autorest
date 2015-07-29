'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the C class.
 * @constructor
 */
function C() { }

/**
 * Validate the payload against the C schema
 *
 * @param {JSON} payload
 *
 */
C.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('C cannot be null.');
  }
  if (payload['httpCode'] !== null && payload['httpCode'] !== undefined && typeof payload['httpCode'] !== 'string') {
    throw new Error('payload[\'httpCode\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to C schema
 *
 * @param {JSON} instance
 *
 */
C.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new C();
