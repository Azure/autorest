/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the D class.
 * @constructor
 * @member {string} [httpStatusCode]
 *
 */
class D {
  constructor() {
  }

  /**
   * Defines the metadata of D
   *
   * @returns {object} metadata of D
   *
   */
  mapper() {
    return {
      required: false,
      serializedName: 'D',
      type: {
        name: 'Composite',
        className: 'D',
        modelProperties: {
          httpStatusCode: {
            required: false,
            serializedName: 'httpStatusCode',
            type: {
              name: 'String'
            }
          }
        }
      }
    };
  }
}

module.exports = D;
