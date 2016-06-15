/*
 */

'use strict';

var models = require('./index');

var util = require('util');

/**
 * @class
 * Initializes a new instance of the StorageAccountCreateParameters class.
 * @constructor
 * The parameters to provide for the account.
 *
 * @member {string} location Resource location
 * 
 * @member {object} [tags] Resource tags
 * 
 * @member {object} [properties]
 * 
 * @member {string} [properties.accountType] Gets or sets the account type.
 * Possible values include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
 * 'Standard_RAGRS', 'Premium_LRS'
 * 
 */
function StorageAccountCreateParameters() {
  StorageAccountCreateParameters['super_'].call(this);
}

util.inherits(StorageAccountCreateParameters, models['BaseResource']);

/**
 * Defines the metadata of StorageAccountCreateParameters
 *
 * @returns {object} metadata of StorageAccountCreateParameters
 *
 */
StorageAccountCreateParameters.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccountCreateParameters',
    type: {
      name: 'Composite',
      className: 'StorageAccountCreateParameters',
      modelProperties: {
        location: {
          required: true,
          serializedName: 'location',
          type: {
            name: 'String'
          }
        },
        tags: {
          required: false,
          serializedName: 'tags',
          type: {
            name: 'Dictionary',
            value: {
                required: false,
                serializedName: 'StringElementType',
                type: {
                  name: 'String'
                }
            }
          }
        },
        properties: {
          required: false,
          serializedName: 'properties',
          type: {
            name: 'Composite',
            className: 'StorageAccountPropertiesCreateParameters'
          }
        }
      }
    }
  };
};

module.exports = StorageAccountCreateParameters;
