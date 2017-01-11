// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsValidation
{
    using Microsoft.Rest;
    using Models;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Test Infrastructure for AutoRest. No server backend exists for these
    /// tests.
    /// </summary>
    public partial interface IAutoRestValidationTest : System.IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        System.Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        Newtonsoft.Json.JsonSerializerSettings SerializationSettings { get; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        Newtonsoft.Json.JsonSerializerSettings DeserializationSettings { get; }

        /// <summary>
        /// Subscription ID.
        /// </summary>
        string SubscriptionId { get; set; }

        /// <summary>
        /// Required string following pattern \d{2}-\d{2}-\d{4}
        /// </summary>
        string ApiVersion { get; set; }


        /// <summary>
        /// Validates input parameters on the method. See swagger for details.
        /// </summary>
        /// <param name='resourceGroupName'>
        /// Required string between 3 and 10 chars with pattern [a-zA-Z0-9]+.
        /// </param>
        /// <param name='id'>
        /// Required int multiple of 10 from 100 to 1000.
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> ValidationOfMethodParametersWithHttpMessagesAsync(string resourceGroupName, int id, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Validates body parameters on the method. See swagger for details.
        /// </summary>
        /// <param name='resourceGroupName'>
        /// Required string between 3 and 10 chars with pattern [a-zA-Z0-9]+.
        /// </param>
        /// <param name='id'>
        /// Required int multiple of 10 from 100 to 1000.
        /// </param>
        /// <param name='body'>
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> ValidationOfBodyWithHttpMessagesAsync(string resourceGroupName, int id, Product body = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse> GetWithConstantInPathWithHttpMessagesAsync(Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

        /// <param name='body'>
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> PostWithConstantInBodyWithHttpMessagesAsync(Product body = default(Product), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

    }
}

