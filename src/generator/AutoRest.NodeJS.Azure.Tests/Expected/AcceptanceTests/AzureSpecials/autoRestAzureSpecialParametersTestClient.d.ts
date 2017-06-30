/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

import { ServiceClient, ServiceClientOptions, RequestOptions, ServiceCallback, HttpOperationResponse, ServiceClientCredentials } from 'ms-rest';
import { AzureServiceClient, AzureServiceClientOptions } from 'ms-rest-azure';
import * as operations from "./operations";

declare class AutoRestAzureSpecialParametersTestClient extends AzureServiceClient {
  /**
   * Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
   * @constructor
   *
   * @class
   * @param {credentials} credentials - Credentials needed for the client to connect to Azure.
   *
   * @param {string} subscriptionId - The subscription id, which appears in the path, always modeled in credentials. The value is always '1234-5678-9012-3456'
   *
   * @param {string} [baseUri] - The base URI of the service.
   *
   * @param {object} [options] - The parameter options
   *
   * @param {Array} [options.filters] - Filters to be added to the request pipeline
   *
   * @param {object} [options.requestOptions] - Options for the underlying request object
   * {@link https://github.com/request/request#requestoptions-callback Options doc}
   *
   * @param {boolean} [options.noRetryPolicy] - If set to true, turn off default retry policy
   *
   * @param {string} [options.apiVersion] - The api version, which appears in the query, the value is always '2015-07-01-preview'
   *
   * @param {string} [options.acceptLanguage] - Gets or sets the preferred language for the response.
   *
   * @param {number} [options.longRunningOperationRetryTimeout] - Gets or sets the retry timeout in seconds for Long Running Operations. Default value is 30.
   *
   * @param {boolean} [options.generateClientRequestId] - When set to true a unique x-ms-client-request-id value is generated and included in each request. Default is true.
   *
   */
  constructor(credentials: ServiceClientCredentials, subscriptionId: string, baseUri?: string, options?: AzureServiceClientOptions);

  credentials: ServiceClientCredentials;

  subscriptionId: string;

  apiVersion: string;

  acceptLanguage: string;

  longRunningOperationRetryTimeout: number;

  generateClientRequestId: boolean;

  // Operation groups
  xMsClientRequestId: operations.XMsClientRequestId;
  subscriptionInCredentials: operations.SubscriptionInCredentials;
  subscriptionInMethod: operations.SubscriptionInMethod;
  apiVersionDefault: operations.ApiVersionDefault;
  apiVersionLocal: operations.ApiVersionLocal;
  skipUrlEncoding: operations.SkipUrlEncoding;
  odata: operations.Odata;
  header: operations.Header;
}

export = AutoRestAzureSpecialParametersTestClient;
