/*
 */

'use strict';

var models = require('./index');

var util = require('util');

/**
 * @class
 * Initializes a new instance of the Pet class.
 * @constructor
 * @summary A pet
 *
 * A group of properties representing a pet.
 *
 * @member {number} [id] The id of the pet. A more detailed description of the
 * id of the pet.
 *
 * @member {object} [category]
 *
 * @member {number} [category.id]
 *
 * @member {string} [category.name]
 *
 * @member {string} name
 *
 * @member {array} photoUrls
 *
 * @member {array} [tags]
 *
 * @member {string} [status] pet status in the store. Possible values include:
 * 'available', 'pending', 'sold'
 *
 */
function Pet() {
}

/**
 * Defines the metadata of Pet
 *
 * @returns {object} metadata of Pet
 *
 */
Pet.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'Pet',
    type: {
      name: 'Composite',
      className: 'Pet',
      modelProperties: {
        id: {
          required: false,
          serializedName: 'id',
          type: {
            name: 'Number'
          }
        },
        category: {
          required: false,
          serializedName: 'category',
          type: {
            name: 'Composite',
            className: 'Category'
          }
        },
        name: {
          required: true,
          serializedName: 'name',
          type: {
            name: 'String'
          }
        },
        photoUrls: {
          required: true,
          serializedName: 'photoUrls',
          type: {
            name: 'Sequence',
            element: {
                required: false,
                serializedName: 'StringElementType',
                type: {
                  name: 'String'
                }
            }
          }
        },
        tags: {
          required: false,
          serializedName: 'tags',
          type: {
            name: 'Sequence',
            element: {
                required: false,
                serializedName: 'TagElementType',
                type: {
                  name: 'Composite',
                  className: 'Tag'
                }
            }
          }
        },
        status: {
          required: false,
          serializedName: 'status',
          type: {
            name: 'String'
          }
        }
      }
    }
  };
};

module.exports = Pet;
