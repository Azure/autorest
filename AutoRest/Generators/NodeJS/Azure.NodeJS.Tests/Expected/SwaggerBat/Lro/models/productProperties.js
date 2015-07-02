'use strict';

var util = require('util');

var models = require('./index');

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
  if (payload['provisioningStateValues'] !== null && payload['provisioningStateValues'] !== undefined && typeof payload['provisioningStateValues'] !== 'string') {
    throw new Error('payload["provisioningStateValues"] must be of type string.');
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
