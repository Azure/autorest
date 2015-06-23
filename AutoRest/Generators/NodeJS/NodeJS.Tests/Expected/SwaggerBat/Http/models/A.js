'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the A class.
 * @constructor
 */
function A() { }

/**
 * Validate the payload against the A schema
 *
 * @param {JSON} payload
 *
 */
A.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('A cannot be null.');
  }
  if (payload['statusCode'] !== null && payload['statusCode'] !== undefined && typeof payload['statusCode'] !== 'string') {
    throw new Error('payload["statusCode"] must be of type string.');
  }

};

/**
 * Deserialize the instance to A schema
 *
 * @param {JSON} instance
 *
 */
A.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new A();
