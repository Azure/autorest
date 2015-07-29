'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Widget class.
 * @constructor
 */
function Widget() { }

/**
 * Validate the payload against the Widget schema
 *
 * @param {JSON} payload
 *
 */
Widget.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Widget cannot be null.');
  }
  if (payload['integer'] !== null && payload['integer'] !== undefined && typeof payload['integer'] !== 'number') {
    throw new Error('payload[\'integer\'] must be of type number.');
  }

  if (payload['string'] !== null && payload['string'] !== undefined && typeof payload['string'] !== 'string') {
    throw new Error('payload[\'string\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to Widget schema
 *
 * @param {JSON} instance
 *
 */
Widget.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new Widget();
