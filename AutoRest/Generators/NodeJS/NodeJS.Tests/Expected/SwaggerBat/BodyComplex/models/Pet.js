'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Pet class.
 * @constructor
 */
function Pet() { }

/**
 * Validate the payload against the Pet schema
 *
 * @param {JSON} payload
 *
 */
Pet.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Pet cannot be null.');
  }
  if (payload['id'] !== null && payload['id'] !== undefined && typeof payload['id'] !== 'number') {
    throw new Error('payload["id"] must be of type number.');
  }

  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'] !== 'string') {
    throw new Error('payload["name"] must be of type string.');
  }

};

/**
 * Deserialize the instance to Pet schema
 *
 * @param {JSON} instance
 *
 */
Pet.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new Pet();
