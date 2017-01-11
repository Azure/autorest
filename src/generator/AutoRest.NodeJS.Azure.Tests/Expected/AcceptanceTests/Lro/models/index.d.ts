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
 * Initializes a new instance of the Resource class.
 * @constructor
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
 * Initializes a new instance of the Sku class.
 * @constructor
 * @member {string} [name]
 *
 * @member {string} [id]
 *
 */
export interface Sku {
  name?: string;
  id?: string;
}

/**
 * @class
 * Initializes a new instance of the Product class.
 * @constructor
 * @member {string} [provisioningState]
 *
 * @member {string} [provisioningStateValues] Possible values include:
 * 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created',
 * 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
 *
 */
export interface Product extends Resource {
  provisioningState?: string;
  provisioningStateValues?: string;
}

/**
 * @class
 * Initializes a new instance of the SubResource class.
 * @constructor
 * @member {string} [id] Sub Resource Id
 *
 */
export interface SubResource extends BaseResource {
  id?: string;
}

/**
 * @class
 * Initializes a new instance of the SubProduct class.
 * @constructor
 * @member {string} [provisioningState]
 *
 * @member {string} [provisioningStateValues] Possible values include:
 * 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created',
 * 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
 *
 */
export interface SubProduct extends SubResource {
  provisioningState?: string;
  provisioningStateValues?: string;
}

/**
 * @class
 * Initializes a new instance of the OperationResultError class.
 * @constructor
 * @member {number} [code] The error code for an operation failure
 *
 * @member {string} [message] The detailed arror message
 *
 */
export interface OperationResultError {
  code?: number;
  message?: string;
}

/**
 * @class
 * Initializes a new instance of the OperationResult class.
 * @constructor
 * @member {string} [status] The status of the request. Possible values
 * include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating',
 * 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
 *
 * @member {object} [error]
 *
 * @member {number} [error.code] The error code for an operation failure
 *
 * @member {string} [error.message] The detailed arror message
 *
 */
export interface OperationResult {
  status?: string;
  error?: OperationResultError;
}

