'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the D class.
 * @constructor
 */
function D() { }

/**
 * Validate the payload against the D schema
 *
 * @param {JSON} payload
 *
 */
D.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('D cannot be null.');
  }
  if (payload['httpStatusCode'] !== null && payload['httpStatusCode'] !== undefined && typeof payload['httpStatusCode'] !== 'string') {
    throw new Error('payload["httpStatusCode"] must be of type string.');
  }

};

/**
 * Deserialize the instance to D schema
 *
 * @param {JSON} instance
 *
 */
D.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new D();
