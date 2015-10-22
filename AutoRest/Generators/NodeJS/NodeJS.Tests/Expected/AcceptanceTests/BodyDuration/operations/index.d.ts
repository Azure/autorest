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
import * as moment from 'moment';
import * as models from '../models';


/**
 * @class
 * Duration
 * __NOTE__: An instance of this class is automatically created for an
 * instance of the AutoRestDurationTestService.
 */
export interface Duration {

    /**
     * Get null duration value
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getNull(options: RequestOptions, callback: ServiceCallback<moment.Duration>): void;
    getNull(callback: ServiceCallback<moment.Duration>): void;

    /**
     * Put a positive duration value
     *
     * @param {moment.duration} durationBody
     * 
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    putPositiveDuration(durationBody: moment.Duration, options: RequestOptions, callback: ServiceCallback<void>): void;
    putPositiveDuration(durationBody: moment.Duration, callback: ServiceCallback<void>): void;

    /**
     * Get a positive duration value
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getPositiveDuration(options: RequestOptions, callback: ServiceCallback<moment.Duration>): void;
    getPositiveDuration(callback: ServiceCallback<moment.Duration>): void;

    /**
     * Get an invalid duration value
     *
     * @param {object} [options]
     *
     * @param {object} [options.customHeaders] headers that will be added to
     * request
     *
     * @param {ServiceCallback} [callback] callback function; see ServiceCallback
     * doc in ms-rest index.d.ts for details
     */
    getInvalid(options: RequestOptions, callback: ServiceCallback<moment.Duration>): void;
    getInvalid(callback: ServiceCallback<moment.Duration>): void;
}
