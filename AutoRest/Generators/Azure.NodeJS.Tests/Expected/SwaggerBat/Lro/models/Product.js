'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Product class.
 * @constructor
 */
function Product() { }

/**
 * Validate the payload against the Product schema
 *
 * @param {JSON} payload
 *
 */
Product.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Product cannot be null.');
  }

  if (payload['provisioningStateValues'] !== null && payload['provisioningStateValues'] !== undefined && typeof payload['provisioningStateValues'] !== 'string') {
    throw new Error('payload["provisioningStateValues"] must be of type string.');
  }

};

/**
 * Deserialize the instance to Product schema
 *
 * @param {JSON} instance
 *
 */
Product.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new Product();
