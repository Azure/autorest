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
class Category {
  constructor() {
  }

  /**
   * Defines the metadata of Category
   *
   * @returns {object} metadata of Category
   *
   */
  mapper() {
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
  }
}

module.exports = Category;
