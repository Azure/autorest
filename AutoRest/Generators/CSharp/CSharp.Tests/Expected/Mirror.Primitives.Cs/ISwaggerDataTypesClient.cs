namespace Fixtures.MirrorPrimitives
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
    public partial interface ISwaggerDataTypesClient : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// </summary>
        /// <param name='responseCode'>
        /// The desired returned status code
        /// </param>
        /// <param name='product'>
        /// The only parameter
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> GetProductWithOperationResponseAsync(string responseCode = default(string), Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='responseCode'>
        /// The desired returned status code
        /// </param>
        /// <param name='product'>
        /// The only parameter
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> PutProductWithOperationResponseAsync(string responseCode = default(string), Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='responseCode'>
        /// The desired returned status code
        /// </param>
        /// <param name='product'>
        /// The only parameter
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> PostProductWithOperationResponseAsync(string responseCode = default(string), Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='responseCode'>
        /// The desired returned status code
        /// </param>
        /// <param name='product'>
        /// The only parameter
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Product>> PatchProductWithOperationResponseAsync(string responseCode = default(string), Product product = default(Product), CancellationToken cancellationToken = default(CancellationToken));

    }
}
