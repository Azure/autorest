'use strict';

/**
 * @class
 * Initializes a new instance of the ProductProperties class.
 * @constructor
 */
function ProductProperties() { }

/**
 * Validate the payload against the ProductProperties schema
 *
 * @param {JSON} payload
 *
 */
ProductProperties.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ProductProperties cannot be null.');
  }
  if (payload['provisioningState'] !== null && payload['provisioningState'] !== undefined && typeof payload['provisioningState'].valueOf() !== 'string') {
    throw new Error('payload[\'provisioningState\'] must be of type string.');
  }

  if (payload['provisioningStateValues'] !== null && payload['provisioningStateValues'] !== undefined && typeof payload['provisioningStateValues'].valueOf() !== 'string') {
    throw new Error('payload[\'provisioningStateValues\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to ProductProperties schema
 *
 * @param {JSON} instance
 *
 */
ProductProperties.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new ProductProperties();
