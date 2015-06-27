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
  if (payload['id'] !== null && payload['id'] !== undefined && typeof payload['id'] !== 'string') {
    throw new Error('payload["id"] must be of type string.');
  }

  if (payload['type'] !== null && payload['type'] !== undefined && typeof payload['type'] !== 'string') {
    throw new Error('payload["type"] must be of type string.');
  }

  if (payload['tags'] !== null && payload['tags'] !== undefined && typeof payload['tags'] === 'object') {
    for(var valueElement in payload['tags']) {
      if (payload['tags'][valueElement] !== null && payload['tags'][valueElement] !== undefined && typeof payload['tags'][valueElement] !== 'string') {
        throw new Error('payload["tags"][valueElement] must be of type string.');
      }
    }
  }

  if (payload['location'] !== null && payload['location'] !== undefined && typeof payload['location'] !== 'string') {
    throw new Error('payload["location"] must be of type string.');
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
