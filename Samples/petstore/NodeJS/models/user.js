/*
 */

'use strict';

/**
 * @class
 * Initializes a new instance of the User class.
 * @constructor
 * @member {number} [id]
 *
 * @member {string} [username]
 *
 * @member {string} [firstName]
 *
 * @member {string} [lastName]
 *
 * @member {string} [email]
 *
 * @member {string} [password]
 *
 * @member {string} [phone]
 *
 * @member {number} [userStatus] User Status
 *
 */
function User() {
}

/**
 * Defines the metadata of User
 *
 * @returns {object} metadata of User
 *
 */
User.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'User',
    type: {
      name: 'Composite',
      className: 'User',
      modelProperties: {
        id: {
          required: false,
          serializedName: 'id',
          type: {
            name: 'Number'
          }
        },
        username: {
          required: false,
          serializedName: 'username',
          type: {
            name: 'String'
          }
        },
        firstName: {
          required: false,
          serializedName: 'firstName',
          type: {
            name: 'String'
          }
        },
        lastName: {
          required: false,
          serializedName: 'lastName',
          type: {
            name: 'String'
          }
        },
        email: {
          required: false,
          serializedName: 'email',
          type: {
            name: 'String'
          }
        },
        password: {
          required: false,
          serializedName: 'password',
          type: {
            name: 'String'
          }
        },
        phone: {
          required: false,
          serializedName: 'phone',
          type: {
            name: 'String'
          }
        },
        userStatus: {
          required: false,
          serializedName: 'userStatus',
          type: {
            name: 'Number'
          }
        }
      }
    }
  };
};

module.exports = User;
