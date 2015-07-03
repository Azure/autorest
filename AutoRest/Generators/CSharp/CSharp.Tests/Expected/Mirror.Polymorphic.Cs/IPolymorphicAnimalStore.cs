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
    public partial interface IPolymorphicAnimalStore
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
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>        
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Animal>> CreateOrUpdatePolymorphicAnimalsWithOperationResponseAsync(Animal animalCreateOrUpdateParameter = default(Animal), Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

    }
}
