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
 * Initializes a new instance of the Datetimerfc1123Wrapper class.
 * @constructor
 * @member {date} [field]
 *
 * @member {date} [now]
 *
 */
class Datetimerfc1123Wrapper {
  constructor() {
  }

  /**
   * Defines the metadata of Datetimerfc1123Wrapper
   *
   * @returns {object} metadata of Datetimerfc1123Wrapper
   *
   */
  mapper() {
    return {
      required: false,
      serializedName: 'datetimerfc1123-wrapper',
      type: {
        name: 'Composite',
        className: 'Datetimerfc1123Wrapper',
        modelProperties: {
          field: {
            required: false,
            serializedName: 'field',
            type: {
              name: 'DateTimeRfc1123'
            }
          },
          now: {
            required: false,
            serializedName: 'now',
            type: {
              name: 'DateTimeRfc1123'
            }
          }
        }
      }
    };
  }
}

module.exports = Datetimerfc1123Wrapper;
