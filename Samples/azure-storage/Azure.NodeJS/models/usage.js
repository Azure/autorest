/*
 */

'use strict';

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the Usage class.
 * @constructor
 * Describes Storage Resource Usage.
 *
 * @member {string} unit Gets the unit of measurement. Possible values include:
 * 'Count', 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond', 'BytesPerSecond'
 *
 * @member {number} currentValue Gets the current count of the allocated
 * resources in the subscription.
 *
 * @member {number} limit Gets the maximum count of the resources that can be
 * allocated in the subscription.
 *
 * @member {object} name Gets the name of the type of usage.
 *
 * @member {string} [name.value] Gets a string describing the resource name.
 *
 * @member {string} [name.localizedValue] Gets a localized string describing
 * the resource name.
 *
 */
function Usage() {
}

/**
 * Defines the metadata of Usage
 *
 * @returns {object} metadata of Usage
 *
 */
Usage.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'Usage',
    type: {
      name: 'Composite',
      className: 'Usage',
      modelProperties: {
        unit: {
          required: true,
          serializedName: 'unit',
          type: {
            name: 'Enum',
            allowedValues: [ 'Count', 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond', 'BytesPerSecond' ]
          }
        },
        currentValue: {
          required: true,
          serializedName: 'currentValue',
          type: {
            name: 'Number'
          }
        },
        limit: {
          required: true,
          serializedName: 'limit',
          type: {
            name: 'Number'
          }
        },
        name: {
          required: true,
          serializedName: 'name',
          type: {
            name: 'Composite',
            className: 'UsageName'
          }
        }
      }
    }
  };
};

module.exports = Usage;
