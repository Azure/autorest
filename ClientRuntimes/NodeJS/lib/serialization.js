// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

function serialize(toSerialize) {
  if (!toSerialize) return;
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
      array.push(serialize(toSerialize[i]));
    }
    return array;
  } else if (typeof toSerialize === 'object') {
    var dictionary = {};
    for (var property in toSerialize) {
      dictionary[property] = serialize(toSerialize[property]);
    }
    return dictionary;
  }
  return toSerialize;
}

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
  return serialize(toSerialize);
};

exports = module.exports;