/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the StorageAccountListResult class.
 * @constructor
 * The list storage accounts operation response.
 *
 */
class StorageAccountListResult extends Array {
  constructor() {
    super();
  }

  /**
   * Defines the metadata of StorageAccountListResult
   *
   * @returns {object} metadata of StorageAccountListResult
   *
   */
  mapper() {
    return {
      required: false,
      serializedName: 'StorageAccountListResult',
      type: {
        name: 'Composite',
        className: 'StorageAccountListResult',
        modelProperties: {
          value: {
            required: false,
            serializedName: '',
            type: {
              name: 'Sequence',
              element: {
                  required: false,
                  serializedName: 'StorageAccountElementType',
                  type: {
                    name: 'Composite',
                    className: 'StorageAccount'
                  }
              }
            }
          }
        }
      }
    };
  }
}

module.exports = StorageAccountListResult;
