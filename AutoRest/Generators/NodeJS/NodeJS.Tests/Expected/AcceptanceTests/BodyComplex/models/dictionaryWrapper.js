'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the DictionaryWrapper class.
 * @constructor
 */
function DictionaryWrapper() { }

/**
 * Validate the payload against the DictionaryWrapper schema
 *
 * @param {JSON} payload
 *
 */
DictionaryWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('DictionaryWrapper cannot be null.');
  }
  if (payload['defaultProgram'] !== null && payload['defaultProgram'] !== undefined && typeof payload['defaultProgram'] === 'object') {
    for(var valueElement in payload['defaultProgram']) {
      if (payload['defaultProgram'][valueElement] !== null && payload['defaultProgram'][valueElement] !== undefined && typeof payload['defaultProgram'][valueElement] !== 'string') {
        throw new Error('payload[\'defaultProgram\'][valueElement] must be of type string.');
      }
    }
  }
};

/**
 * Deserialize the instance to DictionaryWrapper schema
 *
 * @param {JSON} instance
 *
 */
DictionaryWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new DictionaryWrapper();
