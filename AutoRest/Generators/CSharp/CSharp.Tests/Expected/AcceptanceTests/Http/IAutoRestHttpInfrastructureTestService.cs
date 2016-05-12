// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHttp
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IAutoRestHttpInfrastructureTestService : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// Gets the JSON serialization settings.
        /// </summary>
        JsonSerializerSettings SerializationSettings { get; }

        /// <summary>
        /// Gets the JSON deserialization settings.
        /// </summary>
        JsonSerializerSettings DeserializationSettings { get; }


        /// <summary>
        /// Gets the IHttpFailure.
        /// </summary>
        IHttpFailure HttpFailure { get; }

        /// <summary>
        /// Gets the IHttpSuccess.
        /// </summary>
        IHttpSuccess HttpSuccess { get; }

        /// <summary>
        /// Gets the IHttpRedirects.
        /// </summary>
        IHttpRedirects HttpRedirects { get; }

        /// <summary>
        /// Gets the IHttpClientFailure.
        /// </summary>
        IHttpClientFailure HttpClientFailure { get; }

        /// <summary>
        /// Gets the IHttpServerFailure.
        /// </summary>
        IHttpServerFailure HttpServerFailure { get; }

        /// <summary>
        /// Gets the IHttpRetry.
        /// </summary>
        IHttpRetry HttpRetry { get; }

        /// <summary>
        /// Gets the IMultipleResponses.
        /// </summary>
        IMultipleResponses MultipleResponses { get; }

    }
}
