/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the UsageName class.
 * @constructor
 * The Usage Names.
 * @member {string} [value] Gets a string describing the resource name.
 * 
 * @member {string} [localizedValue] Gets a localized string describing the
 * resource name.
 * 
 */
function UsageName(parameters) {
  if (parameters !== null && parameters !== undefined) {
    if (parameters.value !== undefined) {
      this.value = parameters.value;
    }
    if (parameters.localizedValue !== undefined) {
      this.localizedValue = parameters.localizedValue;
    }
  }    
}


/**
 * Validate the payload against the UsageName schema
 *
 * @param {JSON} payload
 *
 */
UsageName.prototype.serialize = function () {
  var payload = {};
  if (this['value'] !== null && this['value'] !== undefined) {
    if (typeof this['value'].valueOf() !== 'string') {
      throw new Error('this[\'value\'] must be of type string.');
    }
    payload['value'] = this['value'];
  }

  if (this['localizedValue'] !== null && this['localizedValue'] !== undefined) {
    if (typeof this['localizedValue'].valueOf() !== 'string') {
      throw new Error('this[\'localizedValue\'] must be of type string.');
    }
    payload['localizedValue'] = this['localizedValue'];
  }

  return payload;
};

/**
 * Deserialize the instance to UsageName schema
 *
 * @param {JSON} instance
 *
 */
UsageName.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance['value'] !== undefined) {
      this['value'] = instance['value'];
    }

    if (instance['localizedValue'] !== undefined) {
      this['localizedValue'] = instance['localizedValue'];
    }
  }

  return this;
};

module.exports = UsageName;
