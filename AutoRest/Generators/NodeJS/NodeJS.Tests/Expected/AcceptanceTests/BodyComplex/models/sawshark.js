/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 * 
 * Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

'use strict';

var models = require('./index');

var util = require('util');

/**
 * @class
 * Initializes a new instance of the Sawshark class.
 * @constructor
 * @member {buffer} [picture]
 * 
 */
function Sawshark(parameters) {
  Sawshark['super_'].call(this, parameters);
  if (parameters !== null && parameters !== undefined) {
    if (parameters.picture !== null && parameters.picture !== undefined) {
      this.picture = parameters.picture;
    }
  }    
}

util.inherits(Sawshark, models['Shark']);

/**
 * Validate the payload against the Sawshark schema
 *
 * @param {JSON} payload
 *
 */
Sawshark.prototype.serialize = function () {
  var payload = Sawshark['super_'].prototype.serialize.call(this);
  if (this['picture']) {
    if (!Buffer.isBuffer(this['picture'])) {
      throw new Error('this[\'picture\'] must be of type buffer.');
    }
    payload['picture'] = this['picture'].toString('base64');
  }

  return payload;
};

/**
 * Deserialize the instance to Sawshark schema
 *
 * @param {JSON} instance
 *
 */
Sawshark.prototype.deserialize = function (instance) {
  Sawshark['super_'].prototype.deserialize.call(this, instance);
  if (instance) {
    if (instance['picture'] !== null && instance['picture'] !== undefined) {
      this['picture'] = new Buffer(instance['picture'], 'base64');
    }
  }

  return this;
};

module.exports = Sawshark;
