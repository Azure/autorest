/*
 */

'use strict';

const models = require('./index');

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
class StorageAccountCreateParameters extends models['BaseResource'] {
  constructor() {
    super();
  }

  /**
   * Defines the metadata of StorageAccountCreateParameters
   *
   * @returns {object} metadata of StorageAccountCreateParameters
   *
   */
  mapper() {
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
  }
}

module.exports = StorageAccountCreateParameters;
