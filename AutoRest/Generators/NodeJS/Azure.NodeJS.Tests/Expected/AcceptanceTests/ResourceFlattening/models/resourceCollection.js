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
  if (payload['productresource']) {
    models['FlattenedProduct'].validate(payload['productresource']);
  }

  if (util.isArray(payload['arrayofresources'])) {
    for (var i = 0; i < payload['arrayofresources'].length; i++) {
      if (payload['arrayofresources'][i]) {
        models['FlattenedProduct'].validate(payload['arrayofresources'][i]);
      }
    }
  }

  if (payload['dictionaryofresources'] && typeof payload['dictionaryofresources'] === 'object') {
    for(var valueElement in payload['dictionaryofresources']) {
      if (payload['dictionaryofresources'][valueElement]) {
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
      instance.arrayofresources.forEach(function(element) {
        if (element !== null && element !== undefined) {
          element = models['FlattenedProduct'].deserialize(element);
        }
        deserializedArray.push(element);
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
