/*
 */


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
export interface User {
  id?: number;
  username?: string;
  firstName?: string;
  lastName?: string;
  email?: string;
  password?: string;
  phone?: string;
  userStatus?: number;
}

/**
 * @class
 * Initializes a new instance of the Category class.
 * @constructor
 * @member {number} [id]
 *
 * @member {string} [name]
 *
 */
export interface Category {
  id?: number;
  name?: string;
}

/**
 * @class
 * Initializes a new instance of the Tag class.
 * @constructor
 * @member {number} [id]
 *
 * @member {string} [name]
 *
 */
export interface Tag {
  id?: number;
  name?: string;
}

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
export interface Pet {
  id?: number;
  category?: Category;
  name: string;
  photoUrls: string[];
  tags?: Tag[];
  status?: string;
}

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
export interface Order {
  id?: number;
  petId?: number;
  quantity?: number;
  shipDate?: Date;
  status?: string;
  complete?: boolean;
}
