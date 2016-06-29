/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the StorageAccountKeys class.
 * @constructor
 * The access keys for the storage account.
 *
 * @member {string} [key1] Gets the value of key 1.
 * 
 * @member {string} [key2] Gets the value of key 2.
 * 
 */
function StorageAccountKeys() {
}

/**
 * Defines the metadata of StorageAccountKeys
 *
 * @returns {object} metadata of StorageAccountKeys
 *
 */
StorageAccountKeys.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccountKeys',
    type: {
      name: 'Composite',
      className: 'StorageAccountKeys',
      modelProperties: {
        key1: {
          required: false,
          serializedName: 'key1',
          type: {
            name: 'String'
          }
        },
        key2: {
          required: false,
          serializedName: 'key2',
          type: {
            name: 'String'
          }
        }
      }
    }
  };
};

module.exports = StorageAccountKeys;
