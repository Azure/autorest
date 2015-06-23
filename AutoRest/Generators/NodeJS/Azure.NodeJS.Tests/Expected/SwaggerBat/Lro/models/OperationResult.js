'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the OperationResult class.
 * @constructor
 */
function OperationResult() { }

/**
 * Validate the payload against the OperationResult schema
 *
 * @param {JSON} payload
 *
 */
OperationResult.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('OperationResult cannot be null.');
  }
  if (payload['status'] !== null && payload['status'] !== undefined && typeof payload['status'] !== 'string') {
    throw new Error('payload["status"] must be of type string.');
  }

  if (payload['error'] !== null && payload['error'] !== undefined) {
    models['OperationResultError'].validate(payload['error']);
  }

};

/**
 * Deserialize the instance to OperationResult schema
 *
 * @param {JSON} instance
 *
 */
OperationResult.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.error !== null && instance.error !== undefined) {
      instance.error = models['OperationResultError'].deserialize(instance.error);
    }

  }
  return instance;
};

module.exports = new OperationResult();
