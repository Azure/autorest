/*
 */

'use strict';

var models = require('./index');

var util = require('util');

/**
 * @class
 * Initializes a new instance of the StorageAccountUpdateParameters class.
 * @constructor
 * The parameters to update on the account.
 *
 * @member {object} [tags] Resource tags
 * 
 * @member {object} [properties]
 * 
 * @member {string} [properties.accountType] Gets or sets the account type.
 * Note that StandardZRS and PremiumLRS accounts cannot be changed to other
 * account types, and other account types cannot be changed to StandardZRS or
 * PremiumLRS. Possible values include: 'Standard_LRS', 'Standard_ZRS',
 * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
 * 
 * @member {object} [properties.customDomain] User domain assigned to the
 * storage account. Name is the CNAME source. Only one custom domain is
 * supported per storage account at this time. To clear the existing custom
 * domain, use an empty string for the custom domain name property.
 * 
 * @member {string} [properties.customDomain.name] Gets or sets the custom
 * domain name. Name is the CNAME source.
 * 
 * @member {boolean} [properties.customDomain.useSubDomain] Indicates whether
 * indirect CName validation is enabled. Default value is false. This should
 * only be set on updates
 * 
 */
function StorageAccountUpdateParameters() {
  StorageAccountUpdateParameters['super_'].call(this);
}

util.inherits(StorageAccountUpdateParameters, models['BaseResource']);

/**
 * Defines the metadata of StorageAccountUpdateParameters
 *
 * @returns {object} metadata of StorageAccountUpdateParameters
 *
 */
StorageAccountUpdateParameters.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccountUpdateParameters',
    type: {
      name: 'Composite',
      className: 'StorageAccountUpdateParameters',
      modelProperties: {
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
            className: 'StorageAccountPropertiesUpdateParameters'
          }
        }
      }
    }
  };
};

module.exports = StorageAccountUpdateParameters;
