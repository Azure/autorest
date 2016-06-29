'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ErrorModel class.
 * @constructor
 */
function ErrorModel() { }

/**
 * Validate the payload against the ErrorModel schema
 *
 * @param {JSON} payload
 *
 */
ErrorModel.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ErrorModel cannot be null.');
  }
  if (payload['status'] !== null && payload['status'] !== undefined && typeof payload['status'] !== 'number') {
    throw new Error('payload[\'status\'] must be of type number.');
  }

  if (payload['message'] !== null && payload['message'] !== undefined && typeof payload['message'].valueOf() !== 'string') {
    throw new Error('payload[\'message\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to ErrorModel schema
 *
 * @param {JSON} instance
 *
 */
ErrorModel.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new ErrorModel();
