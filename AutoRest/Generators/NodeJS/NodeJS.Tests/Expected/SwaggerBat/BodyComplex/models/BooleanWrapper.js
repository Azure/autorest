'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the BooleanWrapper class.
 * @constructor
 */
function BooleanWrapper() { }

/**
 * Validate the payload against the BooleanWrapper schema
 *
 * @param {JSON} payload
 *
 */
BooleanWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('BooleanWrapper cannot be null.');
  }
  if (payload['fieldTrue'] !== null && payload['fieldTrue'] !== undefined && typeof payload['fieldTrue'] !== 'boolean') {
    throw new Error('payload["fieldTrue"] must be of type boolean.');
  }

  if (payload['fieldFalse'] !== null && payload['fieldFalse'] !== undefined && typeof payload['fieldFalse'] !== 'boolean') {
    throw new Error('payload["fieldFalse"] must be of type boolean.');
  }

};

/**
 * Deserialize the instance to BooleanWrapper schema
 *
 * @param {JSON} instance
 *
 */
BooleanWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new BooleanWrapper();
