'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ProductResult class.
 * @constructor
 */
function ProductResult() { }

/**
 * Validate the payload against the ProductResult schema
 *
 * @param {JSON} payload
 *
 */
ProductResult.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ProductResult cannot be null.');
  }
  if (payload['values'] !== null && payload['values'] !== undefined && util.isArray(payload['values'])) {
    payload['values'].forEach(function(element) {
      if (element !== null && element !== undefined) {
        models['Product'].validate(element);
      }
    });
  }

  if (payload['nextLink'] !== null && payload['nextLink'] !== undefined && typeof payload['nextLink'] !== 'string') {
    throw new Error('payload["nextLink"] must be of type string.');
  }

};

/**
 * Deserialize the instance to ProductResult schema
 *
 * @param {JSON} instance
 *
 */
ProductResult.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.values !== null && instance.values !== undefined) {
      var deserializedArray = [];
      instance.values.forEach(function(element1) {
        if (element1 !== null && element1 !== undefined) {
          element1 = models['Product'].deserialize(element1);
        }
        deserializedArray.push(element1);
      });
      instance.values = deserializedArray;
    }

  }
  return instance;
};

module.exports = new ProductResult();
