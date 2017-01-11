/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the Order class.
 * @constructor
 * @member {number} [id]
 *
 * @member {number} [petId]
 *
 * @member {number} [quantity]
 *
 * @member {date} [shipDate]
 *
 * @member {string} [status] Order Status. Possible values include: 'placed',
 * 'approved', 'delivered'
 *
 * @member {boolean} [complete]
 *
 */
function Order() {
}

/**
 * Defines the metadata of Order
 *
 * @returns {object} metadata of Order
 *
 */
Order.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'Order',
    type: {
      name: 'Composite',
      className: 'Order',
      modelProperties: {
        id: {
          required: false,
          readOnly: true,
          serializedName: 'id',
          type: {
            name: 'Number'
          }
        },
        petId: {
          required: false,
          serializedName: 'petId',
          type: {
            name: 'Number'
          }
        },
        quantity: {
          required: false,
          serializedName: 'quantity',
          type: {
            name: 'Number'
          }
        },
        shipDate: {
          required: false,
          serializedName: 'shipDate',
          type: {
            name: 'DateTime'
          }
        },
        status: {
          required: false,
          serializedName: 'status',
          type: {
            name: 'String'
          }
        },
        complete: {
          required: false,
          serializedName: 'complete',
          type: {
            name: 'Boolean'
          }
        }
      }
    }
  };
};

module.exports = Order;
