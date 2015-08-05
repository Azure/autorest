'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Sku class.
 * @constructor
 */
function Sku() { }

/**
 * Validate the payload against the Sku schema
 *
 * @param {JSON} payload
 *
 */
Sku.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Sku cannot be null.');
  }
  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'].valueOf() !== 'string') {
    throw new Error('payload[\'name\'] must be of type string.');
  }

  if (payload['id'] !== null && payload['id'] !== undefined && typeof payload['id'].valueOf() !== 'string') {
    throw new Error('payload[\'id\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to Sku schema
 *
 * @param {JSON} instance
 *
 */
Sku.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new Sku();
