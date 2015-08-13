'use strict';

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the OperationResultError class.
 * @constructor
 */
function OperationResultError() { }

/**
 * Validate the payload against the OperationResultError schema
 *
 * @param {JSON} payload
 *
 */
OperationResultError.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('OperationResultError cannot be null.');
  }
  if (payload['code'] !== null && payload['code'] !== undefined && typeof payload['code'] !== 'number') {
    throw new Error('payload[\'code\'] must be of type number.');
  }

  if (payload['message'] !== null && payload['message'] !== undefined && typeof payload['message'].valueOf() !== 'string') {
    throw new Error('payload[\'message\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to OperationResultError schema
 *
 * @param {JSON} instance
 *
 */
OperationResultError.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new OperationResultError();
