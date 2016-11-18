/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the StorageAccountRegenerateKeyParameters class.
 * @constructor
 * @member {string} keyName
 *
 */
function StorageAccountRegenerateKeyParameters() {
}

/**
 * Defines the metadata of StorageAccountRegenerateKeyParameters
 *
 * @returns {object} metadata of StorageAccountRegenerateKeyParameters
 *
 */
StorageAccountRegenerateKeyParameters.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccountRegenerateKeyParameters',
    type: {
      name: 'Composite',
      className: 'StorageAccountRegenerateKeyParameters',
      modelProperties: {
        keyName: {
          required: true,
          serializedName: 'keyName',
          type: {
            name: 'String'
          }
        }
      }
    }
  };
};

module.exports = StorageAccountRegenerateKeyParameters;
