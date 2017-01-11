/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the StorageAccountPropertiesCreateParameters class.
 * @constructor
 * @member {string} accountType Gets or sets the account type. Possible values
 * include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
 * 'Premium_LRS'
 *
 */
function StorageAccountPropertiesCreateParameters() {
}

/**
 * Defines the metadata of StorageAccountPropertiesCreateParameters
 *
 * @returns {object} metadata of StorageAccountPropertiesCreateParameters
 *
 */
StorageAccountPropertiesCreateParameters.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccountPropertiesCreateParameters',
    type: {
      name: 'Composite',
      className: 'StorageAccountPropertiesCreateParameters',
      modelProperties: {
        accountType: {
          required: true,
          serializedName: 'accountType',
          type: {
            name: 'Enum',
            allowedValues: [ 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS' ]
          }
        }
      }
    }
  };
};

module.exports = StorageAccountPropertiesCreateParameters;
