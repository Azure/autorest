'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the FlattenedProduct class.
 * @constructor
 */
function FlattenedProduct() { }

/**
 * Validate the payload against the FlattenedProduct schema
 *
 * @param {JSON} payload
 *
 */
FlattenedProduct.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('FlattenedProduct cannot be null.');
  }
  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'] !== 'string') {
    throw new Error('payload["name"] must be of type string.');
  }

  if (payload['pname'] !== null && payload['pname'] !== undefined && typeof payload['pname'] !== 'string') {
    throw new Error('payload["pname"] must be of type string.');
  }

  if (payload['provisioningStateValues'] !== null && payload['provisioningStateValues'] !== undefined && typeof payload['provisioningStateValues'] !== 'string') {
    throw new Error('payload["provisioningStateValues"] must be of type string.');
  }

};

/**
 * Deserialize the instance to FlattenedProduct schema
 *
 * @param {JSON} instance
 *
 */
FlattenedProduct.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new FlattenedProduct();
