'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Sawshark class.
 * @constructor
 */
function Sawshark() { }

/**
 * Validate the payload against the Sawshark schema
 *
 * @param {JSON} payload
 *
 */
Sawshark.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Sawshark cannot be null.');
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

  if (payload['picture'] !== null && payload['picture'] !== undefined && !Buffer.isBuffer(payload['picture'])) {
    throw new Error('payload[\'picture\'] must be of type buffer.');
  }
};

/**
 * Deserialize the instance to Sawshark schema
 *
 * @param {JSON} instance
 *
 */
Sawshark.prototype.deserialize = function (instance) {
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

    if (instance.birthday !== null && instance.birthday !== undefined) {
      instance.birthday = new Date(instance.birthday);
    }

    if (instance.picture !== null && instance.picture !== undefined && typeof instance.picture === 'string') {
      instance.picture = new Buffer(instance.picture, 'base64');
    }
  }
  return instance;
};

module.exports = new Sawshark();
