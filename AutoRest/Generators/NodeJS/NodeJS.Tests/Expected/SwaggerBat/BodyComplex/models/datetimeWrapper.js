'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the DatetimeWrapper class.
 * @constructor
 */
function DatetimeWrapper() { }

/**
 * Validate the payload against the DatetimeWrapper schema
 *
 * @param {JSON} payload
 *
 */
DatetimeWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('DatetimeWrapper cannot be null.');
  }
  if (payload['field'] !== null && payload['field'] !== undefined && 
      !(payload['field'] instanceof Date || 
        (typeof payload['field'] === 'string' && !isNaN(Date.parse(payload['field']))))) {
    throw new Error('payload[\'field\'] must be of type date.');
  }

  if (payload['now'] !== null && payload['now'] !== undefined && 
      !(payload['now'] instanceof Date || 
        (typeof payload['now'] === 'string' && !isNaN(Date.parse(payload['now']))))) {
    throw new Error('payload[\'now\'] must be of type date.');
  }

};

/**
 * Deserialize the instance to DatetimeWrapper schema
 *
 * @param {JSON} instance
 *
 */
DatetimeWrapper.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.field !== null && instance.field !== undefined) {
      instance.field = new Date(instance.field);
    }

    if (instance.now !== null && instance.now !== undefined) {
      instance.now = new Date(instance.now);
    }

  }
  return instance;
};

module.exports = new DatetimeWrapper();
