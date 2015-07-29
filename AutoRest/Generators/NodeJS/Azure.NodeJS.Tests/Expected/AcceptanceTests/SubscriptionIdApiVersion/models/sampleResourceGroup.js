'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the SampleResourceGroup class.
 * @constructor
 */
function SampleResourceGroup() { }

/**
 * Validate the payload against the SampleResourceGroup schema
 *
 * @param {JSON} payload
 *
 */
SampleResourceGroup.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('SampleResourceGroup cannot be null.');
  }
  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'] !== 'string') {
    throw new Error('payload[\'name\'] must be of type string.');
  }

  if (payload['location'] !== null && payload['location'] !== undefined && typeof payload['location'] !== 'string') {
    throw new Error('payload[\'location\'] must be of type string.');
  }
};

/**
 * Deserialize the instance to SampleResourceGroup schema
 *
 * @param {JSON} instance
 *
 */
SampleResourceGroup.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new SampleResourceGroup();
