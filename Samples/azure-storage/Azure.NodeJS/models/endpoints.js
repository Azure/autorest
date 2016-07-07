/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the Endpoints class.
 * @constructor
 * The URIs that are used to perform a retrieval of a public blob, queue or
 * table object.
 *
 * @member {string} [blob] Gets the blob endpoint.
 * 
 * @member {string} [queue] Gets the queue endpoint.
 * 
 * @member {string} [table] Gets the table endpoint.
 * 
 * @member {string} [file] Gets the file endpoint.
 * 
 */
function Endpoints() {
}

/**
 * Defines the metadata of Endpoints
 *
 * @returns {object} metadata of Endpoints
 *
 */
Endpoints.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'Endpoints',
    type: {
      name: 'Composite',
      className: 'Endpoints',
      modelProperties: {
        blob: {
          required: false,
          serializedName: 'blob',
          type: {
            name: 'String'
          }
        },
        queue: {
          required: false,
          serializedName: 'queue',
          type: {
            name: 'String'
          }
        },
        table: {
          required: false,
          serializedName: 'table',
          type: {
            name: 'String'
          }
        },
        file: {
          required: false,
          serializedName: 'file',
          type: {
            name: 'String'
          }
        }
      }
    }
  };
};

module.exports = Endpoints;
