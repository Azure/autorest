// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

/**
 * @class
 * Initializes a new instance of the Resource class.
 * @constructor
 */
function Resource() { }

/**
 * Validate the payload against the Resource schema
 *
 * @param {JSON} payload
 *
 */
Resource.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Resource cannot be null.');
  }
  if (payload['id'] !== null && payload['id'] !== undefined && typeof payload['id'] !== 'string') {
    throw new Error('payload["id"] must be of type string.');
  }

  if (payload['location'] === null || payload['location'] === undefined) {
    throw new Error('payload["location"] cannot be null or undefined.');
  }
  if (payload['location'] !== null && payload['location'] !== undefined && typeof payload['location'] !== 'string') {
    throw new Error('payload["location"] must be of type string.');
  }

  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'] !== 'string') {
    throw new Error('payload["name"] must be of type string.');
  }

  if (payload['provisioningState'] !== null && payload['provisioningState'] !== undefined && typeof payload['provisioningState'] !== 'string') {
    throw new Error('payload["provisioningState"] must be of type string.');
  }

  if (payload['tags'] !== null && payload['tags'] !== undefined && typeof payload['tags'] === 'object') {
    for(var valueElement in payload['tags']) {
      if (payload['tags'][valueElement] !== null && payload['tags'][valueElement] !== undefined && typeof payload['tags'][valueElement] !== 'string') {
    throw new Error('payload["tags"][valueElement] must be of type string.');
  }
    }
  }

  if (payload['type'] !== null && payload['type'] !== undefined && typeof payload['type'] !== 'string') {
    throw new Error('payload["type"] must be of type string.');
  }

};

/**
 * Deserialize the instance to Resource schema
 *
 * @param {JSON} instance
 *
 */
Resource.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new Resource();
