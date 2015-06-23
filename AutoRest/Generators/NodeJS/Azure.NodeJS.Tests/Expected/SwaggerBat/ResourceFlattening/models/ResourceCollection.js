'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the ResourceCollection class.
 * @constructor
 */
function ResourceCollection() { }

/**
 * Validate the payload against the ResourceCollection schema
 *
 * @param {JSON} payload
 *
 */
ResourceCollection.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('ResourceCollection cannot be null.');
  }
  if (payload['productresource'] !== null && payload['productresource'] !== undefined) {
    models['FlattenedProduct'].validate(payload['productresource']);
  }

  if (payload['arrayofresources'] !== null && payload['arrayofresources'] !== undefined && util.isArray(payload['arrayofresources'])) {
    payload['arrayofresources'].forEach(function(element) {
      if (element !== null && element !== undefined) {
        models['FlattenedProduct'].validate(element);
      }
    });
  }

  if (payload['dictionaryofresources'] !== null && payload['dictionaryofresources'] !== undefined && typeof payload['dictionaryofresources'] === 'object') {
    for(var valueElement in payload['dictionaryofresources']) {
      if (payload['dictionaryofresources'][valueElement] !== null && payload['dictionaryofresources'][valueElement] !== undefined) {
        models['FlattenedProduct'].validate(payload['dictionaryofresources'][valueElement]);
      }
    }
  }

};

/**
 * Deserialize the instance to ResourceCollection schema
 *
 * @param {JSON} instance
 *
 */
ResourceCollection.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.productresource !== null && instance.productresource !== undefined) {
      instance.productresource = models['FlattenedProduct'].deserialize(instance.productresource);
    }

    if (instance.arrayofresources !== null && instance.arrayofresources !== undefined) {
      var deserializedArray = [];
      instance.arrayofresources.forEach(function(element1) {
        if (element1 !== null && element1 !== undefined) {
          element1 = models['FlattenedProduct'].deserialize(element1);
        }
        deserializedArray.push(element1);
      });
      instance.arrayofresources = deserializedArray;
    }

    if (instance.dictionaryofresources !== null && instance.dictionaryofresources !== undefined) {
      for(var valueElement1 in instance.dictionaryofresources) {
        if (instance.dictionaryofresources[valueElement1] !== null && instance.dictionaryofresources[valueElement1] !== undefined) {
          instance.dictionaryofresources[valueElement1] = models['FlattenedProduct'].deserialize(instance.dictionaryofresources[valueElement1]);
        }
      }
    }

  }
  return instance;
};

module.exports = new ResourceCollection();
