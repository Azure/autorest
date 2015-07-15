namespace Fixtures.SwaggerBatRequiredOptional
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
    public partial interface IAutoRestRequiredOptionalTestService
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
        /// number of items to skip
        /// </summary>
        string RequiredGlobalPath { get; set; }

        /// <summary>
        /// number of items to skip
        /// </summary>
        string RequiredGlobalQuery { get; set; }

        /// <summary>
        /// number of items to skip
        /// </summary>
        int? OptionalGlobalQuery { get; set; }


        IImplicitModel ImplicitModel { get; }

        IExplicitModel ExplicitModel { get; }

    }
}
