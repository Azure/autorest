/*
 */

'use strict';

var models = require('./index');

/**
 * @class
 * Initializes a new instance of the StorageAccountPropertiesUpdateParameters class.
 * @constructor
 * @member {string} [accountType] Gets or sets the account type. Note that
 * StandardZRS and PremiumLRS accounts cannot be changed to other account
 * types, and other account types cannot be changed to StandardZRS or
 * PremiumLRS. Possible values include: 'Standard_LRS', 'Standard_ZRS',
 * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
 *
 * @member {object} [customDomain] User domain assigned to the storage account.
 * Name is the CNAME source. Only one custom domain is supported per storage
 * account at this time. To clear the existing custom domain, use an empty
 * string for the custom domain name property.
 *
 * @member {string} [customDomain.name] Gets or sets the custom domain name.
 * Name is the CNAME source.
 *
 * @member {boolean} [customDomain.useSubDomain] Indicates whether indirect
 * CName validation is enabled. Default value is false. This should only be set
 * on updates
 *
 */
function StorageAccountPropertiesUpdateParameters() {
}

/**
 * Defines the metadata of StorageAccountPropertiesUpdateParameters
 *
 * @returns {object} metadata of StorageAccountPropertiesUpdateParameters
 *
 */
StorageAccountPropertiesUpdateParameters.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccountPropertiesUpdateParameters',
    type: {
      name: 'Composite',
      className: 'StorageAccountPropertiesUpdateParameters',
      modelProperties: {
        accountType: {
          required: false,
          serializedName: 'accountType',
          type: {
            name: 'Enum',
            allowedValues: [ 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS' ]
          }
        },
        customDomain: {
          required: false,
          serializedName: 'customDomain',
          type: {
            name: 'Composite',
            className: 'CustomDomain'
          }
        }
      }
    }
  };
};

module.exports = StorageAccountPropertiesUpdateParameters;
