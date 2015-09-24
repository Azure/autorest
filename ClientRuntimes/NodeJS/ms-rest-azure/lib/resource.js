// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

/**
 * @class
 * Initializes a new instance of the Resource class.
 * @constructor
 */
function Resource(parameters) {
  if (parameters !== null && parameters !== undefined) {
    if (parameters['id'] !== null && parameters['id'] !== undefined) {
      this.id = parameters['id'];
    }
    if (parameters['location'] !== null && parameters['location'] !== undefined) {
      this.location = parameters['location'];
    }
    if (parameters['name'] !== null && parameters['name'] !== undefined) {
      this.name = parameters['name'];
    }
    if (parameters['provisioningState'] !== null && parameters['provisioningState'] !== undefined) {
      this.provisioningState = parameters['provisioningState'];
    }
    if (parameters['tags'] !== null && parameters['tags'] !== undefined) {
      this.tags = parameters['tags'];
    }
    if (parameters['type'] !== null && parameters['type'] !== undefined) {
      this.type = parameters['type'];
    }
  }
}

/**
 * Validate the payload against the Resource schema
 *
 * @param {JSON} payload
 *
 */
Resource.prototype.serialize = function () {
  var payload = {};
  if (this.id !== null && this.id !== undefined) {
    if (typeof this.id !== 'string') {
      throw new Error('this.id must be of type string.');
    }
    payload.id = this.id;
  }

  if (this.location === null || this.location === undefined || typeof this.location !== 'string') {
    throw new Error('this.location cannot be null or undefined and it must be of type string.');
  }
  payload.location = this.location;
  
  if (this.name !== null && this.name !== undefined) {
    if (typeof this.name !== 'string') {
      throw new Error('this.name must be of type string.');
    }
    payload.name = this.name;
  }
  
  if (this.provisioningState !== null && this.provisioningState !== undefined) {
    if (typeof this.provisioningState !== 'string') {
      throw new Error('this.provisioningState must be of type string.');
    }
    if (payload.properties === null || payload.properties === undefined) {
      payload.properties = {};
    }
    payload.properties.provisioningState = this.provisioningState;
  }
  
  if (this.tags !== null && this.tags !== undefined) {
    if (typeof this.tags !== 'object') {
      throw new Error('this.tags must be of type object.');
    }
    for (var valueElement in this.tags) {
      if (this.tags[valueElement] !== null && this.tags[valueElement] !== undefined && typeof this.tags[valueElement] !== 'string') {
        throw new Error('this.tags[valueElement] must be of type string.');
      }
    }
    payload.tags = this.tags;
  }
  
  if (this.type !== null && this.type !== undefined) {
    if (typeof this.type !== 'string') {
      throw new Error('this.type must be of type string.');
    }
    payload.type = this.type;
  }

  return payload;
};

/**
 * Deserialize the instance to Resource schema
 *
 * @param {JSON} instance
 *
 */
Resource.prototype.deserialize = function (instance) {
  if (instance !== null && instance !== undefined) {
    if (instance['id'] !== null && instance['id'] !== undefined) {
      this.id = instance['id'];
    }
    if (instance['location'] !== null && instance['location'] !== undefined) {
      this.location = instance['location'];
    }
    if (instance['name'] !== null && instance['name'] !== undefined) {
      this.name = instance['name'];
    }
    if (instance['properties'] !== null && instance['properties'] !== undefined) {
      if (instance['properties']['provisioningState'] !== null && instance['properties']['provisioningState'] !== undefined) {
        this.provisioningState = instance['properties']['provisioningState'];
      }
    }
    if (instance['tags'] !== null && instance['tags'] !== undefined) {
      this.tags = instance['tags'];
    }
    if (instance['type'] !== null && instance['type'] !== undefined) {
      this.type = instance['type'];
    }
  }
};

module.exports = Resource;
