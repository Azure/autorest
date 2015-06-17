// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

/**
 * Serializes the JSON Object. It serializes Buffer object to a 
 * 'base64' encoded string and a Date Object to a string 
 * compliant with ISO8601 format.
 * 
 * @param {Object} toSerialize
 * 
 * @returns {Object} serializedObject
 */
exports.serializeObject = function (toSerialize) {
  if (toSerialize === null || toSerialize === undefined) return null;
  if (Buffer.isBuffer(toSerialize)) {
    toSerialize = toSerialize.toString('base64');
    return toSerialize;
  }
  else if (toSerialize instanceof Date) {
    return toSerialize.toISOString();
  }
  else if (Array.isArray(toSerialize)) {
    var array = [];
    for (var i = 0; i < toSerialize.length; i++) {
      array.push(exports.serializeObject(toSerialize[i]));
    }
    return array;
  } else if (typeof toSerialize === 'object') {
    var dictionary = {};
    for (var property in toSerialize) {
      dictionary[property] = exports.serializeObject(toSerialize[property]);
    }
    return dictionary;
  }
  return toSerialize;
};

/**
 * Deserializes the given input in to a Date() object if it is compliant 
 * with ISO 8601 format
 * 
 * @param {string} input
 * 
 * @returns {Date} Date Object
 */
exports.deserializeDate = function (input) {
  if (exports.isValidISODateTime(input)) {
    return new Date(input);
  } else {
    throw new Error('Invalid input  \'' + input + '\'.  It cannot be deserialized as a Date().');
  }
};

/**
 * Validates if the given string is compliant with the ISO 8601 
 * Date and DateTime format
 * 
 * @param {string} dateString
 * 
 * @returns {bool} true - if valid, false otherwise
 */
exports.isValidISODateTime = function (dateString) {
  var re = /^([0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])?(T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9]))?$/i;
  return re.test(dateString);
};

exports = module.exports;