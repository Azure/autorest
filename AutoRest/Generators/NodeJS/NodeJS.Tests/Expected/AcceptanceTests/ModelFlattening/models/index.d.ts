/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 * 
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */


/**
 * @class
 * Initializes a new instance of the ErrorModel class.
 * @constructor
 * @member {number} [status]
 * 
 * @member {string} [message]
 * 
 * @member {object} [parentError]
 * 
 */
export interface ErrorModel {
    status?: number;
    message?: string;
    parentError?: ErrorModel;
}

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
export interface Resource {
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
 * @member {string} [flattenedProductType]
 * 
 * @member {string} [provisioningStateValues] Possible values include:
 * 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating', 'Created',
 * 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
 * 
 * @member {string} [provisioningState]
 * 
 */
export interface FlattenedProduct extends Resource {
    pname?: string;
    flattenedProductType?: string;
    provisioningStateValues?: string;
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
 * @member {string} [productresource.flattenedProductType]
 * 
 * @member {string} [productresource.provisioningStateValues] Possible values
 * include: 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating',
 * 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted', 'OK'
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

/**
 * @class
 * Initializes a new instance of the BaseProduct class.
 * @constructor
 * The product documentation.
 * @member {string} productId Unique identifier representing a specific
 * product for a given latitude & longitude. For example, uberX in San
 * Francisco will have a different product_id than uberX in Los Angeles.
 * 
 * @member {string} [description] Description of product.
 * 
 */
export interface BaseProduct {
    productId: string;
    description?: string;
}

/**
 * @class
 * Initializes a new instance of the SimpleProduct class.
 * @constructor
 * The product documentation.
 * @member {string} maxProductDisplayName Display name of product.
 * 
 * @member {string} [genericValue] Generic URL value.
 * 
 * @member {string} [odatavalue] URL value.
 * 
 */
export interface SimpleProduct extends BaseProduct {
    maxProductDisplayName: string;
    genericValue?: string;
    odatavalue?: string;
}

/**
 * @class
 * Initializes a new instance of the FlattenParameterGroup class.
 * @constructor
 * Additional parameters for the putSimpleProductWithGrouping operation.
 * @member {string} name Product name with value 'groupproduct'
 * 
 * @member {string} productId Unique identifier representing a specific
 * product for a given latitude & longitude. For example, uberX in San
 * Francisco will have a different product_id than uberX in Los Angeles.
 * 
 * @member {string} [description] Description of product.
 * 
 * @member {string} maxProductDisplayName Display name of product.
 * 
 * @member {string} [genericValue] Generic URL value.
 * 
 * @member {string} [odatavalue] URL value.
 * 
 */
export interface FlattenParameterGroup {
    name: string;
    productId: string;
    description?: string;
    maxProductDisplayName: string;
    genericValue?: string;
    odatavalue?: string;
}

/**
 * @class
 * Initializes a new instance of the GenericUrl class.
 * @constructor
 * The Generic URL.
 * @member {string} [genericValue] Generic URL value.
 * 
 */
export interface GenericUrl {
    genericValue?: string;
}
