namespace Fixtures.PetstoreV2
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    /// <summary>
    /// This is a sample server Petstore server.  You can find out more about
    /// Swagger at &lt;a
    /// href=&quot;http://swagger.io&quot;&gt;http://swagger.io&lt;/a&gt; or
    /// on irc.freenode.net, #swagger.  For this sample, you can use the api
    /// key &quot;special-key&quot; to test the authorization filters
    /// </summary>
    public partial interface ISwaggerPetstoreV2 : IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        Uri BaseUri { get; set; }

        /// <summary>
        /// </summary>
        /// <param name='body'>
        /// Pet object that needs to be added to the store
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Pet>> AddPetWithOperationResponseAsync(Pet body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='body'>
        /// Pet object that needs to be added to the store
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> UpdatePetWithOperationResponseAsync(Pet body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Multiple status values can be provided with comma seperated strings
        /// </summary>
        /// <param name='status'>
        /// Status values that need to be considered for filter
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Pet>>> FindPetsByStatusWithOperationResponseAsync(IList<string> status, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Muliple tags can be provided with comma seperated strings. Use
        /// tag1, tag2, tag3 for testing.
        /// </summary>
        /// <param name='tags'>
        /// Tags to filter by
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IList<Pet>>> FindPetsByTagsWithOperationResponseAsync(IList<string> tags, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Returns a single pet
        /// </summary>
        /// <param name='petId'>
        /// Id of pet to return
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Pet>> GetPetByIdWithOperationResponseAsync(long? petId, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='petId'>
        /// Id of pet that needs to be updated
        /// </param>
        /// <param name='name'>
        /// Updated name of the pet
        /// </param>
        /// <param name='status'>
        /// Updated status of the pet
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> UpdatePetWithFormWithOperationResponseAsync(long? petId, string name = default(string), string status = default(string), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='apiKey'>
        /// </param>
        /// <param name='petId'>
        /// Pet id to delete
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DeletePetWithOperationResponseAsync(long? petId, string apiKey = default(string), CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// Returns a map of status codes to quantities
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<IDictionary<string, int?>>> GetInventoryWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='body'>
        /// order placed for purchasing the pet
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Order>> PlaceOrderWithOperationResponseAsync(Order body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// For valid response try integer IDs with value &lt;= 5 or &gt; 10.
        /// Other values will generated exceptions
        /// </summary>
        /// <param name='orderId'>
        /// Id of pet that needs to be fetched
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<Order>> GetOrderByIdWithOperationResponseAsync(string orderId, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// For valid response try integer IDs with value &lt; 1000. Anything
        /// above 1000 or nonintegers will generate API errors
        /// </summary>
        /// <param name='orderId'>
        /// Id of the order that needs to be deleted
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DeleteOrderWithOperationResponseAsync(string orderId, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// This can only be done by the logged in user.
        /// </summary>
        /// <param name='body'>
        /// Created user object
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> CreateUserWithOperationResponseAsync(User body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='body'>
        /// List of user object
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> CreateUsersWithArrayInputWithOperationResponseAsync(IList<User> body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='body'>
        /// List of user object
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> CreateUsersWithListInputWithOperationResponseAsync(IList<User> body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='username'>
        /// The user name for login
        /// </param>
        /// <param name='password'>
        /// The password for login in clear text
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<string>> LoginUserWithOperationResponseAsync(string username, string password, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> LogoutUserWithOperationResponseAsync(CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// </summary>
        /// <param name='username'>
        /// The name that needs to be fetched. Use user1 for testing.
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse<User>> GetUserByNameWithOperationResponseAsync(string username, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// This can only be done by the logged in user.
        /// </summary>
        /// <param name='username'>
        /// name that need to be deleted
        /// </param>
        /// <param name='body'>
        /// Updated user object
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> UpdateUserWithOperationResponseAsync(string username, User body, CancellationToken cancellationToken = default(CancellationToken));

        /// <summary>
        /// This can only be done by the logged in user.
        /// </summary>
        /// <param name='username'>
        /// The name that needs to be deleted
        /// </param>
        /// <param name='cancellationToken'>
        /// Cancellation token.
        /// </param>
        Task<HttpOperationResponse> DeleteUserWithOperationResponseAsync(string username, CancellationToken cancellationToken = default(CancellationToken));

    }
}
