
namespace Petstore
{
    using System.Threading.Tasks;
   using Models;

    /// <summary>
    /// Extension methods for SwaggerPetstore.
    /// </summary>
    public static partial class SwaggerPetstoreExtensions
    {
            /// <summary>
            /// Fake endpoint to test byte array in body parameter for adding a new pet to
            /// the store
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Pet object in the form of byte array
            /// </param>
            public static void AddPetUsingByteArray(this ISwaggerPetstore operations, string body = default(string))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).AddPetUsingByteArrayAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Fake endpoint to test byte array in body parameter for adding a new pet to
            /// the store
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Pet object in the form of byte array
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task AddPetUsingByteArrayAsync(this ISwaggerPetstore operations, string body = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.AddPetUsingByteArrayWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Add a new pet to the store
            /// </summary>
            /// <remarks>
            /// Adds a new pet to the store. You may receive an HTTP invalid input if your
            /// pet is invalid.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            public static void AddPet(this ISwaggerPetstore operations, Pet body = default(Pet))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).AddPetAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Add a new pet to the store
            /// </summary>
            /// <remarks>
            /// Adds a new pet to the store. You may receive an HTTP invalid input if your
            /// pet is invalid.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task AddPetAsync(this ISwaggerPetstore operations, Pet body = default(Pet), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.AddPetWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Update an existing pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            public static void UpdatePet(this ISwaggerPetstore operations, Pet body = default(Pet))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).UpdatePetAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Update an existing pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task UpdatePetAsync(this ISwaggerPetstore operations, Pet body = default(Pet), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.UpdatePetWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Finds Pets by status
            /// </summary>
            /// <remarks>
            /// Multiple status values can be provided with comma seperated strings
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='status'>
            /// Status values that need to be considered for filter
            /// </param>
            public static System.Collections.Generic.IList<Pet> FindPetsByStatus(this ISwaggerPetstore operations, System.Collections.Generic.IList<string> status = default(System.Collections.Generic.IList<string>))
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).FindPetsByStatusAsync(status), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Finds Pets by status
            /// </summary>
            /// <remarks>
            /// Multiple status values can be provided with comma seperated strings
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='status'>
            /// Status values that need to be considered for filter
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.Collections.Generic.IList<Pet>> FindPetsByStatusAsync(this ISwaggerPetstore operations, System.Collections.Generic.IList<string> status = default(System.Collections.Generic.IList<string>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.FindPetsByStatusWithHttpMessagesAsync(status, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Finds Pets by tags
            /// </summary>
            /// <remarks>
            /// Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
            /// tag3 for testing.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='tags'>
            /// Tags to filter by
            /// </param>
            public static System.Collections.Generic.IList<Pet> FindPetsByTags(this ISwaggerPetstore operations, System.Collections.Generic.IList<string> tags = default(System.Collections.Generic.IList<string>))
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).FindPetsByTagsAsync(tags), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Finds Pets by tags
            /// </summary>
            /// <remarks>
            /// Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
            /// tag3 for testing.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='tags'>
            /// Tags to filter by
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.Collections.Generic.IList<Pet>> FindPetsByTagsAsync(this ISwaggerPetstore operations, System.Collections.Generic.IList<string> tags = default(System.Collections.Generic.IList<string>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.FindPetsByTagsWithHttpMessagesAsync(tags, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Fake endpoint to test byte array return by 'Find pet by ID'
            /// </summary>
            /// <remarks>
            /// Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate
            /// API error conditions
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet that needs to be fetched
            /// </param>
            public static string FindPetsWithByteArray(this ISwaggerPetstore operations, long petId)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).FindPetsWithByteArrayAsync(petId), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Fake endpoint to test byte array return by 'Find pet by ID'
            /// </summary>
            /// <remarks>
            /// Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate
            /// API error conditions
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet that needs to be fetched
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<string> FindPetsWithByteArrayAsync(this ISwaggerPetstore operations, long petId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.FindPetsWithByteArrayWithHttpMessagesAsync(petId, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Find pet by ID
            /// </summary>
            /// <remarks>
            /// Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate
            /// API error conditions
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet that needs to be fetched
            /// </param>
            public static Pet GetPetById(this ISwaggerPetstore operations, long petId)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).GetPetByIdAsync(petId), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Find pet by ID
            /// </summary>
            /// <remarks>
            /// Returns a pet when ID &lt; 10.  ID &gt; 10 or nonintegers will simulate
            /// API error conditions
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet that needs to be fetched
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<Pet> GetPetByIdAsync(this ISwaggerPetstore operations, long petId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetPetByIdWithHttpMessagesAsync(petId, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Updates a pet in the store with form data
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet that needs to be updated
            /// </param>
            /// <param name='name'>
            /// Updated name of the pet
            /// </param>
            /// <param name='status'>
            /// Updated status of the pet
            /// </param>
            public static void UpdatePetWithForm(this ISwaggerPetstore operations, string petId, string name = default(string), string status = default(string))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).UpdatePetWithFormAsync(petId, name, status), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Updates a pet in the store with form data
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet that needs to be updated
            /// </param>
            /// <param name='name'>
            /// Updated name of the pet
            /// </param>
            /// <param name='status'>
            /// Updated status of the pet
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task UpdatePetWithFormAsync(this ISwaggerPetstore operations, string petId, string name = default(string), string status = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.UpdatePetWithFormWithHttpMessagesAsync(petId, name, status, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Deletes a pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// Pet id to delete
            /// </param>
            /// <param name='apiKey'>
            /// </param>
            public static void DeletePet(this ISwaggerPetstore operations, long petId, string apiKey = default(string))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).DeletePetAsync(petId, apiKey), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes a pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// Pet id to delete
            /// </param>
            /// <param name='apiKey'>
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task DeletePetAsync(this ISwaggerPetstore operations, long petId, string apiKey = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.DeletePetWithHttpMessagesAsync(petId, apiKey, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// uploads an image
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet to update
            /// </param>
            /// <param name='additionalMetadata'>
            /// Additional data to pass to server
            /// </param>
            /// <param name='file'>
            /// file to upload
            /// </param>
            public static void UploadFile(this ISwaggerPetstore operations, long petId, string additionalMetadata = default(string), System.IO.Stream file = default(System.IO.Stream))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).UploadFileAsync(petId, additionalMetadata, file), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// uploads an image
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='petId'>
            /// ID of pet to update
            /// </param>
            /// <param name='additionalMetadata'>
            /// Additional data to pass to server
            /// </param>
            /// <param name='file'>
            /// file to upload
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task UploadFileAsync(this ISwaggerPetstore operations, long petId, string additionalMetadata = default(string), System.IO.Stream file = default(System.IO.Stream), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.UploadFileWithHttpMessagesAsync(petId, additionalMetadata, file, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Returns pet inventories by status
            /// </summary>
            /// <remarks>
            /// Returns a map of status codes to quantities
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static System.Collections.Generic.IDictionary<string, int?> GetInventory(this ISwaggerPetstore operations)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).GetInventoryAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Returns pet inventories by status
            /// </summary>
            /// <remarks>
            /// Returns a map of status codes to quantities
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<System.Collections.Generic.IDictionary<string, int?>> GetInventoryAsync(this ISwaggerPetstore operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetInventoryWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Place an order for a pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// order placed for purchasing the pet
            /// </param>
            public static Order PlaceOrder(this ISwaggerPetstore operations, Order body = default(Order))
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).PlaceOrderAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Place an order for a pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// order placed for purchasing the pet
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<Order> PlaceOrderAsync(this ISwaggerPetstore operations, Order body = default(Order), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.PlaceOrderWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Find purchase order by ID
            /// </summary>
            /// <remarks>
            /// For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other
            /// values will generated exceptions
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='orderId'>
            /// ID of pet that needs to be fetched
            /// </param>
            public static Order GetOrderById(this ISwaggerPetstore operations, string orderId)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).GetOrderByIdAsync(orderId), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Find purchase order by ID
            /// </summary>
            /// <remarks>
            /// For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other
            /// values will generated exceptions
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='orderId'>
            /// ID of pet that needs to be fetched
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<Order> GetOrderByIdAsync(this ISwaggerPetstore operations, string orderId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetOrderByIdWithHttpMessagesAsync(orderId, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Delete purchase order by ID
            /// </summary>
            /// <remarks>
            /// For valid response try integer IDs with value &lt; 1000. Anything above
            /// 1000 or nonintegers will generate API errors
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='orderId'>
            /// ID of the order that needs to be deleted
            /// </param>
            public static void DeleteOrder(this ISwaggerPetstore operations, string orderId)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).DeleteOrderAsync(orderId), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Delete purchase order by ID
            /// </summary>
            /// <remarks>
            /// For valid response try integer IDs with value &lt; 1000. Anything above
            /// 1000 or nonintegers will generate API errors
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='orderId'>
            /// ID of the order that needs to be deleted
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task DeleteOrderAsync(this ISwaggerPetstore operations, string orderId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.DeleteOrderWithHttpMessagesAsync(orderId, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Create user
            /// </summary>
            /// <remarks>
            /// This can only be done by the logged in user.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Created user object
            /// </param>
            public static void CreateUser(this ISwaggerPetstore operations, User body = default(User))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).CreateUserAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Create user
            /// </summary>
            /// <remarks>
            /// This can only be done by the logged in user.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// Created user object
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task CreateUserAsync(this ISwaggerPetstore operations, User body = default(User), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.CreateUserWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Creates list of users with given input array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            public static void CreateUsersWithArrayInput(this ISwaggerPetstore operations, System.Collections.Generic.IList<User> body = default(System.Collections.Generic.IList<User>))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).CreateUsersWithArrayInputAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates list of users with given input array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task CreateUsersWithArrayInputAsync(this ISwaggerPetstore operations, System.Collections.Generic.IList<User> body = default(System.Collections.Generic.IList<User>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.CreateUsersWithArrayInputWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Creates list of users with given input array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            public static void CreateUsersWithListInput(this ISwaggerPetstore operations, System.Collections.Generic.IList<User> body = default(System.Collections.Generic.IList<User>))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).CreateUsersWithListInputAsync(body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates list of users with given input array
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task CreateUsersWithListInputAsync(this ISwaggerPetstore operations, System.Collections.Generic.IList<User> body = default(System.Collections.Generic.IList<User>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.CreateUsersWithListInputWithHttpMessagesAsync(body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Logs user into the system
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// The user name for login
            /// </param>
            /// <param name='password'>
            /// The password for login in clear text
            /// </param>
            public static string LoginUser(this ISwaggerPetstore operations, string username = default(string), string password = default(string))
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).LoginUserAsync(username, password), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Logs user into the system
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// The user name for login
            /// </param>
            /// <param name='password'>
            /// The password for login in clear text
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<string> LoginUserAsync(this ISwaggerPetstore operations, string username = default(string), string password = default(string), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.LoginUserWithHttpMessagesAsync(username, password, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Logs out current logged in user session
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static void LogoutUser(this ISwaggerPetstore operations)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).LogoutUserAsync(), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Logs out current logged in user session
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task LogoutUserAsync(this ISwaggerPetstore operations, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.LogoutUserWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Get user by user name
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// The name that needs to be fetched. Use user1 for testing.
            /// </param>
            public static User GetUserByName(this ISwaggerPetstore operations, string username)
            {
                return System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).GetUserByNameAsync(username), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None, System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Get user by user name
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// The name that needs to be fetched. Use user1 for testing.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task<User> GetUserByNameAsync(this ISwaggerPetstore operations, string username, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                using (var _result = await operations.GetUserByNameWithHttpMessagesAsync(username, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Updated user
            /// </summary>
            /// <remarks>
            /// This can only be done by the logged in user.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// name that need to be deleted
            /// </param>
            /// <param name='body'>
            /// Updated user object
            /// </param>
            public static void UpdateUser(this ISwaggerPetstore operations, string username, User body = default(User))
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).UpdateUserAsync(username, body), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Updated user
            /// </summary>
            /// <remarks>
            /// This can only be done by the logged in user.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// name that need to be deleted
            /// </param>
            /// <param name='body'>
            /// Updated user object
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task UpdateUserAsync(this ISwaggerPetstore operations, string username, User body = default(User), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.UpdateUserWithHttpMessagesAsync(username, body, null, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Delete user
            /// </summary>
            /// <remarks>
            /// This can only be done by the logged in user.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// The name that needs to be deleted
            /// </param>
            public static void DeleteUser(this ISwaggerPetstore operations, string username)
            {
                System.Threading.Tasks.Task.Factory.StartNew(s => ((ISwaggerPetstore)s).DeleteUserAsync(username), operations, System.Threading.CancellationToken.None, System.Threading.Tasks.TaskCreationOptions.None,  System.Threading.Tasks.TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Delete user
            /// </summary>
            /// <remarks>
            /// This can only be done by the logged in user.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='username'>
            /// The name that needs to be deleted
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async System.Threading.Tasks.Task DeleteUserAsync(this ISwaggerPetstore operations, string username, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken))
            {
                await operations.DeleteUserWithHttpMessagesAsync(username, null, cancellationToken).ConfigureAwait(false);
            }

    }
}
