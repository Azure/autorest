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
    public partial interface ISequenceRequestResponseTest
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
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>        
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Pet>>> AddPetWithHttpMessagesAsync(IList<Pet> pets, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Adds new pet stylesin the store.  Duplicates are allowed
        /// </summary>
        /// <param name='petStyle'>
        /// Pet style to add to the store
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>        
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> AddPetStylesWithHttpMessagesAsync(IList<int?> petStyle, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Updates new pet stylesin the store.  Duplicates are allowed
        /// </summary>
        /// <param name='petStyle'>
        /// Pet style to add to the store
        /// </param>
        /// <param name='customHeaders'>
        /// Headers that will be added to request.
        /// </param>        
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<int?>>> UpdatePetStylesWithHttpMessagesAsync(IList<int?> petStyle, Dictionary<string, List<string>> customHeaders = null, CancellationToken cancellationToken = default(CancellationToken));

    }
}
