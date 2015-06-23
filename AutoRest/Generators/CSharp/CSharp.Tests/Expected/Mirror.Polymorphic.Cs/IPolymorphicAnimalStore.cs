namespace Fixtures.MirrorPolymorphic
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// Some cool documentation.
    /// </summary>
    public partial interface IPolymorphicAnimalStore : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// The Products endpoint returns information about the Uber products
        /// offered at a given location. The response includes the display
        /// name and other details about each product, and lists the products
        /// in the proper display order.
        /// </summary>
        /// <param name='animalCreateOrUpdateParameter'>
        /// An Animal
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Animal>> CreateOrUpdatePolymorphicAnimalsWithOperationResponseAsync(Animal animalCreateOrUpdateParameter = default(Animal), CancellationToken cancellationToken = default(CancellationToken));

    }
}
