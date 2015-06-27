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
  if (payload['id'] !== null && payload['id'] !== undefined && typeof payload['id'] !== 'string') {
    throw new Error('payload["id"] must be of type string.');
  }

  if (payload['type'] !== null && payload['type'] !== undefined && typeof payload['type'] !== 'string') {
    throw new Error('payload["type"] must be of type string.');
  }

  if (payload['tags'] !== null && payload['tags'] !== undefined && typeof payload['tags'] !== 'string') {
    throw new Error('payload["tags"] must be of type string.');
  }

  if (payload['location'] !== null && payload['location'] !== undefined && typeof payload['location'] !== 'string') {
    throw new Error('payload["location"] must be of type string.');
  }

  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'] !== 'string') {
    throw new Error('payload["name"] must be of type string.');
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
