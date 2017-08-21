// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.Azure.Fluent.AcceptanceTestsAzureSpecials
{
    using Fixtures.Azure;
    using Fixtures.Azure.Fluent;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// HeaderOperations operations.
    /// </summary>
    public partial interface IHeaderOperations
    {
        /// <summary>
        /// Send foo-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0
        /// in the header of the request
        /// </summary>
        /// <param name='fooClientRequestId'>
        /// The fooRequestId
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        Task<AzureOperationHeaderResponse<HeaderCustomNamedRequestIdHeadersInner>> CustomNamedRequestIdWithHttpMessagesAsync(string fooClientRequestId, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send foo-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0
        /// in the header of the request, via a parameter group
        /// </summary>
        /// <param name='headerCustomNamedRequestIdParamGroupingParameters'>
        /// Additional parameters for the operation
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        Task<AzureOperationHeaderResponse<HeaderCustomNamedRequestIdParamGroupingHeadersInner>> CustomNamedRequestIdParamGroupingWithHttpMessagesAsync(HeaderCustomNamedRequestIdParamGroupingParametersInner headerCustomNamedRequestIdParamGroupingParameters, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
        /// <summary>
        /// Send foo-client-request-id = 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0
        /// in the header of the request
        /// </summary>
        /// <param name='fooClientRequestId'>
        /// The fooRequestId
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        /// <exception cref="ErrorException">
        /// Thrown when the operation returned an invalid status code
        /// </exception>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown when a required parameter is null
        /// </exception>
        Task<AzureOperationResponse<bool,HeaderCustomNamedRequestIdHeadHeadersInner>> CustomNamedRequestIdHeadWithHttpMessagesAsync(string fooClientRequestId, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));
    }
}
