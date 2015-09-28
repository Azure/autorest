// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

/**
 * @class
 * Initializes a new instance of the SubResource class.
 * @constructor
 */
function SubResource(parameters) {
  if (parameters !== null && parameters !== undefined) {
    if (parameters['id'] !== null && parameters['id'] !== undefined) {
      this.id = parameters['id'];
    }
  }
}

/**
 * Validate the payload against the SubResource schema
 *
 * @param {JSON} payload
 *
 */
SubResource.prototype.serialize = function () {
  var payload = {};
  if (this.id !== null && this.id !== undefined) {
    if (typeof this.id !== 'string') {
      throw new Error('this.id must be of type string.');
    }
    payload.id = this.id;
  }

  return payload;
};

/**
 * Deserialize the instance to SubResource schema
 *
 * @param {JSON} instance
 *
 */
SubResource.prototype.deserialize = function (instance) {
  if (instance !== null && instance !== undefined) {
    if (instance['id'] !== null && instance['id'] !== undefined) {
      this.id = instance['id'];
    }
  }
};

module.exports = SubResource;
