namespace Fixtures.MirrorSequences
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// A sample API that uses a petstore as an example to demonstrate
    /// features in the swagger-2.0 specification
    /// </summary>
    public partial interface ISequenceRequestResponseTest : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// Creates a new pet in the store.  Duplicates are allowed
        /// </summary>
        /// <param name='pets'>
        /// Pets to add to the store
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Pet>>> AddPetWithOperationResponseAsync(IList<Pet> pets, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Adds new pet stylesin the store.  Duplicates are allowed
        /// </summary>
        /// <param name='petStyle'>
        /// Pet style to add to the store
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> AddPetStylesWithOperationResponseAsync(IList<int?> petStyle, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Updates new pet stylesin the store.  Duplicates are allowed
        /// </summary>
        /// <param name='petStyle'>
        /// Pet style to add to the store
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> UpdatePetStylesWithOperationResponseAsync(IList<int?> petStyle, CancellationToken cancellationToken = default(CancellationToken));

    }
}
