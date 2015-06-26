'use strict';

var util = require('util');

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Group class.
 * @constructor
 */
function Group() { }

/**
 * Validate the payload against the Group schema
 *
 * @param {JSON} payload
 *
 */
Group.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('Group cannot be null.');
  }
  if (payload['name'] !== null && payload['name'] !== undefined && typeof payload['name'] !== 'string') {
    throw new Error('payload["name"] must be of type string.');
  }

  if (payload['location'] !== null && payload['location'] !== undefined && typeof payload['location'] !== 'string') {
    throw new Error('payload["location"] must be of type string.');
  }

};

/**
 * Deserialize the instance to Group schema
 *
 * @param {JSON} instance
 *
 */
Group.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new Group();
