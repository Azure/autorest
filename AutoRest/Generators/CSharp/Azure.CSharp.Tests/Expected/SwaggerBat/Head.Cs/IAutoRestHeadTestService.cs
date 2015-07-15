namespace Fixtures.Azure.SwaggerBatHead
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Azure;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IAutoRestHeadTestService
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        JsonSerializerSettings SerializationSettings { get; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        JsonSerializerSettings DeserializationSettings { get; }        

        /// <summary>
        /// Subscription credentials which uniquely identify Microsoft Azure
        /// subscription.
        /// </summary>
        SubscriptionCloudCredentials Credentials { get; }

        /// <summary>
        /// Gets or sets the preferred language for the response.
        /// </summary>
        string AcceptLanguage { get; }

        /// <summary>
        /// The retry timeout for Long Running Operations.
        /// </summary>
        int? LongRunningOperationRetryTimeout { get; set; }


        IHttpSuccessOperations HttpSuccess { get; }

    }
}
