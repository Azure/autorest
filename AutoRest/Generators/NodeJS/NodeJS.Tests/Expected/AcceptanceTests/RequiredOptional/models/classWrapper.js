'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ClassWrapper class.
 * @constructor
 */
function ClassWrapper() { }

/**
 * Validate the payload against the ClassWrapper schema
 *
 * @param {JSON} payload
 *
 */
ClassWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ClassWrapper cannot be null.');
  }
  if (payload['value'] === null || payload['value'] === undefined) {
    throw new Error('payload[\'value\'] cannot be null or undefined.');
  }
  if (payload['value'] !== null && payload['value'] !== undefined) {
    models['Product'].validate(payload['value']);
  }

};

/**
 * Deserialize the instance to ClassWrapper schema
 *
 * @param {JSON} instance
 *
 */
ClassWrapper.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.value !== null && instance.value !== undefined) {
      instance.value = models['Product'].deserialize(instance.value);
    }

  }
  return instance;
};

module.exports = new ClassWrapper();
