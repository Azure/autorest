/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the Category class.
 * @constructor
 * @member {number} [id]
 *
 * @member {string} [name]
 *
 */
function Category() {
}

/**
 * Defines the metadata of Category
 *
 * @returns {object} metadata of Category
 *
 */
Category.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'Category',
    type: {
      name: 'Composite',
      className: 'Category',
      modelProperties: {
        id: {
          required: false,
          serializedName: 'id',
          type: {
            name: 'Number'
          }
        },
        name: {
          required: false,
          serializedName: 'name',
          type: {
            name: 'String'
          }
        }
      }
    }
  };
};

module.exports = Category;
