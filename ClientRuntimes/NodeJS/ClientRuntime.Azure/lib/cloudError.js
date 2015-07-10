// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';

/**
 * @class
 * Initializes a new instance of the CloudError class.
 * @constructor
 */
function CloudError() { }

/**
 * Validate the payload against the CloudError schema
 *
 * @param {JSON} payload
 *
 */
CloudError.prototype.validate = function (payload) {
  return payload;
};

/**
 * Deserialize the instance to CloudError schema
 *
 * @param {JSON} instance
 *
 */
CloudError.prototype.deserialize = function (instance) {
  if (instance) {
    if (instance.details !== null && instance.details !== undefined) {
      var deserializedArray = [];
      instance.details.forEach(function(element1) {
        if (element1 !== null && element1 !== undefined) {
          element1 = this.deserialize(element1);
        }
        deserializedArray.push(element1);
      });
      instance.details = deserializedArray;
    }

  }
  return instance;
};

module.exports = new CloudError();
