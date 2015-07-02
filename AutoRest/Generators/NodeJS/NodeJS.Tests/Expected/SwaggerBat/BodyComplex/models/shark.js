'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Shark class.
 * @constructor
 */
function Shark() { }

/**
 * Validate the payload against the Shark schema
 *
 * @param {JSON} payload
 *
 */
Shark.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Shark cannot be null.');
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
    payload['siblings'].forEach(function(element) {
      if (element !== null && element !== undefined) {
        if(element['dtype'] !== null && element['dtype'] !== undefined && models.discriminators[element['dtype']]) {
          models.discriminators[element['dtype']].validate(element);
        } else {
          throw new Error('No discriminator field "dtype" was found in parameter "element".');
        }
      }
    });
  }

  if (payload['age'] !== null && payload['age'] !== undefined && typeof payload['age'] !== 'number') {
    throw new Error('payload[\'age\'] must be of type number.');
  }

  if (payload['birthday'] === null || payload['birthday'] === undefined) {
    throw new Error('payload[\'birthday\'] cannot be null or undefined.');
  }
  if (payload['birthday'] !== null && payload['birthday'] !== undefined && 
      !(payload['birthday'] instanceof Date || 
        (typeof payload['birthday'] === 'string' && !isNaN(Date.parse(payload['birthday']))))) {
    throw new Error('payload[\'birthday\'] must be of type date.');
  }

};

/**
 * Deserialize the instance to Shark schema
 *
 * @param {JSON} instance
 *
 */
Shark.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.siblings !== null && instance.siblings !== undefined) {
      var deserializedArray = [];
      instance.siblings.forEach(function(element1) {
        if (element1 !== null && element1 !== undefined) {
          if(element1['dtype'] !== null && element1['dtype'] !== undefined && models.discriminators[element1['dtype']]) {
            element1 = models.discriminators[element1['dtype']].deserialize(element1);
          } else {
            throw new Error('No discriminator field "dtype" was found in parameter "element1".');
          }
        }
        deserializedArray.push(element1);
      });
      instance.siblings = deserializedArray;
    }

    if (instance.birthday !== null && instance.birthday !== undefined) {
      instance.birthday = new Date(instance.birthday);
    }

  }
  return instance;
};

module.exports = new Shark();
