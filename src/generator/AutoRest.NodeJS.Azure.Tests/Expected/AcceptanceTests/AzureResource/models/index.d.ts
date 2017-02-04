/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

import * as msRestAzure from 'ms-rest-azure';
exports.BaseResource = msRestAzure.BaseResource;
exports.CloudError = msRestAzure.CloudError;

/**
 * @class
 * Initializes a new instance of the ErrorModel class.
 * @constructor
 * @member {number} [status]
 *
 * @member {string} [message]
 *
 */
export interface ErrorModel {
  status?: number;
  message?: string;
}

/**
 * @class
 * Initializes a new instance of the Resource class.
 * @constructor
 * Some resource
 *
 * @member {string} [id] Resource Id
 *
 * @member {string} [type] Resource Type
 *
 * @member {object} [tags]
 *
 * @member {string} [location] Resource Location
 *
 * @member {string} [name] Resource Name
 *
 */
export interface Resource extends BaseResource {
  id?: string;
  type?: string;
  tags?: { [propertyName: string]: string };
  location?: string;
  name?: string;
}

/**
 * @class
 * Initializes a new instance of the FlattenedProduct class.
 * @constructor
 * @member {string} [pname]
 *
 * @member {number} [lsize]
 *
 * @member {string} [provisioningState]
 *
 */
export interface FlattenedProduct extends Resource {
  pname?: string;
  lsize?: number;
  provisioningState?: string;
}

/**
 * @class
 * Initializes a new instance of the ResourceCollection class.
 * @constructor
 * @member {object} [productresource]
 *
 * @member {string} [productresource.pname]
 *
 * @member {number} [productresource.lsize]
 *
 * @member {string} [productresource.provisioningState]
 *
 * @member {array} [arrayofresources]
 *
 * @member {object} [dictionaryofresources]
 *
 */
export interface ResourceCollection {
  productresource?: FlattenedProduct;
  arrayofresources?: FlattenedProduct[];
  dictionaryofresources?: { [propertyName: string]: FlattenedProduct };
}
