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
  if (payload['properties'] !== null && payload['properties'] !== undefined) {
    models['ProductProperties'].validate(payload['properties']);
  }
};

/**
 * Deserialize the instance to Product schema
 *
 * @param {JSON} instance
 *
 */
Product.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.properties !== null && instance.properties !== undefined) {
      instance.properties = models['ProductProperties'].deserialize(instance.properties);
    }
  }
  return instance;
};

module.exports = new Product();
