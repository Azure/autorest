namespace Fixtures.Azure.SwaggerBatAzureSpecials
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Azure;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial interface IAutoRestAzureSpecialParametersTestClient : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        ISubscriptionInCredentialsOperations SubscriptionInCredentials { get; }

        ISubscriptionInMethodOperations SubscriptionInMethod { get; }

        IApiVersionDefaultOperations ApiVersionDefault { get; }

        IApiVersionLocalOperations ApiVersionLocal { get; }

        ISkipUrlEncodingOperations SkipUrlEncoding { get; }

        }
}
