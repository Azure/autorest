'use strict';

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
  if (payload['id'] === null || payload['id'] === undefined || typeof payload['id'] !== 'number') {
    throw new Error('payload[\'id\'] cannot be null or undefined and it must be of type number.');
  }

  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'].valueOf() !== 'string') {
    throw new Error('payload[\'name\'] must be of type string.');
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
