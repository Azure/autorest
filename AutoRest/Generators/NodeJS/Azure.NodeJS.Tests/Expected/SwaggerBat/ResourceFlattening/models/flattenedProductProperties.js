'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the FlattenedProductProperties class.
 * @constructor
 */
function FlattenedProductProperties() { }

/**
 * Validate the payload against the FlattenedProductProperties schema
 *
 * @param {JSON} payload
 *
 */
FlattenedProductProperties.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('FlattenedProductProperties cannot be null.');
  }
  if (payload['pname'] !== null && payload['pname'] !== undefined && typeof payload['pname'] !== 'string') {
    throw new Error('payload[\'pname\'] must be of type string.');
  }

  if (payload['provisioningStateValues'] !== null && payload['provisioningStateValues'] !== undefined && typeof payload['provisioningStateValues'] !== 'string') {
    throw new Error('payload[\'provisioningStateValues\'] must be of type string.');
  }

  if (payload['provisioningState'] !== null && payload['provisioningState'] !== undefined && typeof payload['provisioningState'] !== 'string') {
    throw new Error('payload[\'provisioningState\'] must be of type string.');
  }

};

/**
 * Deserialize the instance to FlattenedProductProperties schema
 *
 * @param {JSON} instance
 *
 */
FlattenedProductProperties.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new FlattenedProductProperties();
