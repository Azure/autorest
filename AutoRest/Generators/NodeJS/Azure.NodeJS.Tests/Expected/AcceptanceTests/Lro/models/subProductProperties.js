'use strict';

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the SubProductProperties class.
 * @constructor
 */
function SubProductProperties() { }

/**
 * Validate the payload against the SubProductProperties schema
 *
 * @param {JSON} payload
 *
 */
SubProductProperties.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('SubProductProperties cannot be null.');
  }
  if (payload['provisioningState'] !== null && payload['provisioningState'] !== undefined && typeof payload['provisioningState'].valueOf() !== 'string') {
    throw new Error('payload[\'provisioningState\'] must be of type string.');
  }

  if (payload['provisioningStateValues'] !== null && payload['provisioningStateValues'] !== undefined && typeof payload['provisioningStateValues'].valueOf() !== 'string') {
    throw new Error('payload[\'provisioningStateValues\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to SubProductProperties schema
 *
 * @param {JSON} instance
 *
 */
SubProductProperties.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new SubProductProperties();
