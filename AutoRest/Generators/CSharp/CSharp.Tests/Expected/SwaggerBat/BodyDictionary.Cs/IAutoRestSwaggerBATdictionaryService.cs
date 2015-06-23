namespace Fixtures.SwaggerBatBodyDictionary
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest Swagger BAT
    /// </summary>
    public partial interface IAutoRestSwaggerBATdictionaryService : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        IDictionary Dictionary { get; }

        }
}
