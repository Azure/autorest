namespace Fixtures.Azure.SwaggerBatSubscriptionIdApiVersion
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
    /// Some cool documentation.
    /// </summary>
    public partial interface IMicrosoftAzureTestUrl
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        IGroupOperations Group { get; }

        }
}
