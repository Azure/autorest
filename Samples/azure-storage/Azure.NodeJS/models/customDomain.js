/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the CustomDomain class.
 * @constructor
 * The custom domain assigned to this storage account. This can be set via
 * Update.
 *
 * @member {string} name Gets or sets the custom domain name. Name is the
 * CNAME source.
 * 
 * @member {boolean} [useSubDomain] Indicates whether indirect CName
 * validation is enabled. Default value is false. This should only be set on
 * updates
 * 
 */
function CustomDomain() {
}

/**
 * Defines the metadata of CustomDomain
 *
 * @returns {object} metadata of CustomDomain
 *
 */
CustomDomain.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'CustomDomain',
    type: {
      name: 'Composite',
      className: 'CustomDomain',
      modelProperties: {
        name: {
          required: true,
          serializedName: 'name',
          type: {
            name: 'String'
          }
        },
        useSubDomain: {
          required: false,
          serializedName: 'useSubDomain',
          type: {
            name: 'Boolean'
          }
        }
      }
    }
  };
};

module.exports = CustomDomain;
