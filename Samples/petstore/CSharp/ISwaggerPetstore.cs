
namespace Petstore
{
    using Models;

    /// <summary>
    /// This is a sample server Petstore server.  You can find out more about
    /// Swagger at &lt;a
    /// href="http://swagger.io"&gt;http://swagger.io&lt;/a&gt; or on
    /// irc.freenode.net, #swagger.  For this sample, you can use the api key
    /// "special-key" to test the authorization filters
    /// </summary>
    public partial interface ISwaggerPetstore : System.IDisposable
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        System.Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        Newtonsoft.Json.JsonSerializerSettings SerializationSettings { get; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        Newtonsoft.Json.JsonSerializerSettings DeserializationSettings { get; }


            /// <summary>
        /// Fake endpoint to test byte array in body parameter for adding a
        /// new pet to the store
        /// </summary>
        /// <param name='body'>
        /// Pet object in the form of byte array
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> AddPetUsingByteArrayWithHttpMessagesAsync(string body = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Add a new pet to the store
        /// </summary>
        /// <remarks>
        /// Adds a new pet to the store. You may receive an HTTP invalid input
        /// if your pet is invalid.
        /// </remarks>
        /// <param name='body'>
        /// Pet object that needs to be added to the store
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> AddPetWithHttpMessagesAsync(Pet body = default(Pet), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Update an existing pet
        /// </summary>
        /// <param name='body'>
        /// Pet object that needs to be added to the store
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> UpdatePetWithHttpMessagesAsync(Pet body = default(Pet), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Finds Pets by status
        /// </summary>
        /// <remarks>
        /// Multiple status values can be provided with comma seperated strings
        /// </remarks>
        /// <param name='status'>
        /// Status values that need to be considered for filter
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<System.Collections.Generic.IList<Pet>>> FindPetsByStatusWithHttpMessagesAsync(System.Collections.Generic.IList<string> status = default(System.Collections.Generic.IList<string>), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Finds Pets by tags
        /// </summary>
        /// <remarks>
        /// Muliple tags can be provided with comma seperated strings. Use
        /// tag1, tag2, tag3 for testing.
        /// </remarks>
        /// <param name='tags'>
        /// Tags to filter by
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<System.Collections.Generic.IList<Pet>>> FindPetsByTagsWithHttpMessagesAsync(System.Collections.Generic.IList<string> tags = default(System.Collections.Generic.IList<string>), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Fake endpoint to test byte array return by 'Find pet by ID'
        /// </summary>
        /// <remarks>
        /// Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will
        /// simulate API error conditions
        /// </remarks>
        /// <param name='petId'>
        /// ID of pet that needs to be fetched
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<string>> FindPetsWithByteArrayWithHttpMessagesAsync(long petId, System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Find pet by ID
        /// </summary>
        /// <remarks>
        /// Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will
        /// simulate API error conditions
        /// </remarks>
        /// <param name='petId'>
        /// ID of pet that needs to be fetched
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<Pet>> GetPetByIdWithHttpMessagesAsync(long petId, System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Updates a pet in the store with form data
        /// </summary>
        /// <param name='petId'>
        /// ID of pet that needs to be updated
        /// </param>
        /// <param name='name'>
        /// Updated name of the pet
        /// </param>
        /// <param name='status'>
        /// Updated status of the pet
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> UpdatePetWithFormWithHttpMessagesAsync(string petId, string name = default(string), string status = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Deletes a pet
        /// </summary>
        /// <param name='petId'>
        /// Pet id to delete
        /// </param>
        /// <param name='apiKey'>
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> DeletePetWithHttpMessagesAsync(long petId, string apiKey = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// uploads an image
        /// </summary>
        /// <param name='petId'>
        /// ID of pet to update
        /// </param>
        /// <param name='additionalMetadata'>
        /// Additional data to pass to server
        /// </param>
        /// <param name='file'>
        /// file to upload
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> UploadFileWithHttpMessagesAsync(long petId, string additionalMetadata = default(string), System.IO.Stream file = default(System.IO.Stream), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Returns pet inventories by status
        /// </summary>
        /// <remarks>
        /// Returns a map of status codes to quantities
        /// </remarks>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<System.Collections.Generic.IDictionary<string, int?>>> GetInventoryWithHttpMessagesAsync(System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Place an order for a pet
        /// </summary>
        /// <param name='body'>
        /// order placed for purchasing the pet
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<Order>> PlaceOrderWithHttpMessagesAsync(Order body = default(Order), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Find purchase order by ID
        /// </summary>
        /// <remarks>
        /// For valid response try integer IDs with value &lt;= 5 or &gt; 10.
        /// Other values will generated exceptions
        /// </remarks>
        /// <param name='orderId'>
        /// ID of pet that needs to be fetched
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<Order>> GetOrderByIdWithHttpMessagesAsync(string orderId, System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Delete purchase order by ID
        /// </summary>
        /// <remarks>
        /// For valid response try integer IDs with value &lt; 1000. Anything
        /// above 1000 or nonintegers will generate API errors
        /// </remarks>
        /// <param name='orderId'>
        /// ID of the order that needs to be deleted
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> DeleteOrderWithHttpMessagesAsync(string orderId, System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Create user
        /// </summary>
        /// <remarks>
        /// This can only be done by the logged in user.
        /// </remarks>
        /// <param name='body'>
        /// Created user object
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> CreateUserWithHttpMessagesAsync(User body = default(User), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Creates list of users with given input array
        /// </summary>
        /// <param name='body'>
        /// List of user object
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> CreateUsersWithArrayInputWithHttpMessagesAsync(System.Collections.Generic.IList<User> body = default(System.Collections.Generic.IList<User>), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Creates list of users with given input array
        /// </summary>
        /// <param name='body'>
        /// List of user object
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> CreateUsersWithListInputWithHttpMessagesAsync(System.Collections.Generic.IList<User> body = default(System.Collections.Generic.IList<User>), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Logs user into the system
        /// </summary>
        /// <param name='username'>
        /// The user name for login
        /// </param>
        /// <param name='password'>
        /// The password for login in clear text
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<string>> LoginUserWithHttpMessagesAsync(string username = default(string), string password = default(string), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Logs out current logged in user session
        /// </summary>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> LogoutUserWithHttpMessagesAsync(System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Get user by user name
        /// </summary>
        /// <param name='username'>
        /// The name that needs to be fetched. Use user1 for testing.
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse<User>> GetUserByNameWithHttpMessagesAsync(string username, System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Updated user
        /// </summary>
        /// <remarks>
        /// This can only be done by the logged in user.
        /// </remarks>
        /// <param name='username'>
        /// name that need to be deleted
        /// </param>
        /// <param name='body'>
        /// Updated user object
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> UpdateUserWithHttpMessagesAsync(string username, User body = default(User), System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

        /// <summary>
        /// Delete user
        /// </summary>
        /// <remarks>
        /// This can only be done by the logged in user.
        /// </remarks>
        /// <param name='username'>
        /// The name that needs to be deleted
        /// </param>
        /// <param name='customHeaders'>
        /// The headers that will be added to request.
        /// </param>
        /// <param name='cancellationToken'>
        /// The cancellation token.
        /// </param>
        System.Threading.Tasks.Task<Microsoft.Rest.HttpOperationResponse> DeleteUserWithHttpMessagesAsync(string username, System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<string>> customHeaders = null, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));

    }
}
