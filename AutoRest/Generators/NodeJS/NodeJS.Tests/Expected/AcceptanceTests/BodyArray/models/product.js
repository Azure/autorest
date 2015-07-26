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
  if (payload['integer'] !== null && payload['integer'] !== undefined && typeof payload['integer'] !== 'number') {
    throw new Error('payload[\'integer\'] must be of type number.');
  }

  if (payload['string'] !== null && payload['string'] !== undefined && typeof payload['string'] !== 'string') {
    throw new Error('payload[\'string\'] must be of type string.');
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
