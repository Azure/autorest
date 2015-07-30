'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Fish class.
 * @constructor
 */
function Fish() { }

/**
 * Validate the payload against the Fish schema
 *
 * @param {JSON} payload
 *
 */
Fish.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Fish cannot be null.');
  }
  if (payload['species'] !== null && payload['species'] !== undefined && typeof payload['species'] !== 'string') {
    throw new Error('payload[\'species\'] must be of type string.');
  }

  if (payload['length'] === null || payload['length'] === undefined) {
    throw new Error('payload[\'length\'] cannot be null or undefined.');
  }
  if (payload['length'] !== null && payload['length'] !== undefined && typeof payload['length'] !== 'number') {
    throw new Error('payload[\'length\'] must be of type number.');
  }

  if (payload['siblings'] !== null && payload['siblings'] !== undefined && util.isArray(payload['siblings'])) {
    for (var i = 0; i < payload['siblings'].length; i++) {
      if (payload['siblings'][i] !== null && payload['siblings'][i] !== undefined) {
        if(payload['siblings'][i]['dtype'] !== null && payload['siblings'][i]['dtype'] !== undefined && models.discriminators[payload['siblings'][i]['dtype']]) {
          models.discriminators[payload['siblings'][i]['dtype']].validate(payload['siblings'][i]);
        } else {
          throw new Error('No discriminator field "dtype" was found in parameter "payload[\'siblings\'][i]".');
        }
      }
    }
  }
};

/**
 * Deserialize the instance to Fish schema
 *
 * @param {JSON} instance
 *
 */
Fish.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.siblings !== null && instance.siblings !== undefined) {
      var deserializedArray = [];
      instance.siblings.forEach(function(element) {
        if (element !== null && element !== undefined) {
          if(element['dtype'] !== null && element['dtype'] !== undefined && models.discriminators[element['dtype']]) {
            element = models.discriminators[element['dtype']].deserialize(element);
          } else {
            throw new Error('No discriminator field "dtype" was found in parameter "element".');
          }
        }
        deserializedArray.push(element);
      });
      instance.siblings = deserializedArray;
    }
  }
  return instance;
};

module.exports = new Fish();
