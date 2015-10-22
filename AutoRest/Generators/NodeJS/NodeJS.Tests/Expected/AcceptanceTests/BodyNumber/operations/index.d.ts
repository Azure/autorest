/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 * 
 * Code generated by Microsoft (R) AutoRest Code Generator 0.11.0.0
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
*/

import { ServiceClientOptions, RequestOptions, ServiceCallback } from 'ms-rest';
import * as models from '../models';


/**
 * @class
 * Number
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestNumberTestService.
 */
export interface Number {

    /**
     * Get null Number value
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getNull(options: RequestOptions, callback: ServiceCallback<number>): void;
    getNull(callback: ServiceCallback<number>): void;

    /**
     * Get invalid float Number value
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getInvalidFloat(options: RequestOptions, callback: ServiceCallback<number>): void;
    getInvalidFloat(callback: ServiceCallback<number>): void;

    /**
     * Get invalid double Number value
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getInvalidDouble(options: RequestOptions, callback: ServiceCallback<number>): void;
    getInvalidDouble(callback: ServiceCallback<number>): void;

    /**
     * Put big float value 3.402823e+20
     *
     * @param {number} numberBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putBigFloat(numberBody: number, options: RequestOptions, callback: ServiceCallback<void>): void;
    putBigFloat(numberBody: number, callback: ServiceCallback<void>): void;

    /**
     * Get big float value 3.402823e+20
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getBigFloat(options: RequestOptions, callback: ServiceCallback<number>): void;
    getBigFloat(callback: ServiceCallback<number>): void;

    /**
     * Put big double value 2.5976931e+101
     *
     * @param {number} numberBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putBigDouble(numberBody: number, options: RequestOptions, callback: ServiceCallback<void>): void;
    putBigDouble(numberBody: number, callback: ServiceCallback<void>): void;

    /**
     * Get big double value 2.5976931e+101
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getBigDouble(options: RequestOptions, callback: ServiceCallback<number>): void;
    getBigDouble(callback: ServiceCallback<number>): void;

    /**
     * Put big double value 99999999.99
     *
     * @param {number} numberBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putBigDoublePositiveDecimal(numberBody: number, options: RequestOptions, callback: ServiceCallback<void>): void;
    putBigDoublePositiveDecimal(numberBody: number, callback: ServiceCallback<void>): void;

    /**
     * Get big double value 99999999.99
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getBigDoublePositiveDecimal(options: RequestOptions, callback: ServiceCallback<number>): void;
    getBigDoublePositiveDecimal(callback: ServiceCallback<number>): void;

    /**
     * Put big double value -99999999.99
     *
     * @param {number} numberBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putBigDoubleNegativeDecimal(numberBody: number, options: RequestOptions, callback: ServiceCallback<void>): void;
    putBigDoubleNegativeDecimal(numberBody: number, callback: ServiceCallback<void>): void;

    /**
     * Get big double value -99999999.99
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getBigDoubleNegativeDecimal(options: RequestOptions, callback: ServiceCallback<number>): void;
    getBigDoubleNegativeDecimal(callback: ServiceCallback<number>): void;

    /**
     * Put small float value 3.402823e-20
     *
     * @param {number} numberBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putSmallFloat(numberBody: number, options: RequestOptions, callback: ServiceCallback<void>): void;
    putSmallFloat(numberBody: number, callback: ServiceCallback<void>): void;

    /**
     * Get big double value 3.402823e-20
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getSmallFloat(options: RequestOptions, callback: ServiceCallback<number>): void;
    getSmallFloat(callback: ServiceCallback<number>): void;

    /**
     * Put small double value 2.5976931e-101
     *
     * @param {number} numberBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putSmallDouble(numberBody: number, options: RequestOptions, callback: ServiceCallback<void>): void;
    putSmallDouble(numberBody: number, callback: ServiceCallback<void>): void;

    /**
     * Get big double value 2.5976931e-101
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getSmallDouble(options: RequestOptions, callback: ServiceCallback<number>): void;
    getSmallDouble(callback: ServiceCallback<number>): void;
}
