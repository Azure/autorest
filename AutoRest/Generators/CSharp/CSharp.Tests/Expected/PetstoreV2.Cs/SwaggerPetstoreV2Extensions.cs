namespace Fixtures.PetstoreV2
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Models;

    public static partial class SwaggerPetstoreV2Extensions
    {
            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            public static Pet AddPet(this ISwaggerPetstoreV2 operations, Pet body)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).AddPetAsync(body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Pet> AddPetAsync( this ISwaggerPetstoreV2 operations, Pet body, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Pet> result = await operations.AddPetWithOperationResponseAsync(body, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            public static void UpdatePet(this ISwaggerPetstoreV2 operations, Pet body)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).UpdatePetAsync(body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// Pet object that needs to be added to the store
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task UpdatePetAsync( this ISwaggerPetstoreV2 operations, Pet body, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.UpdatePetWithOperationResponseAsync(body, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Multiple status values can be provided with comma seperated strings
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='status'>
            /// Status values that need to be considered for filter
            /// </param>
            public static IList<Pet> FindPetsByStatus(this ISwaggerPetstoreV2 operations, IList<string> status)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).FindPetsByStatusAsync(status), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Multiple status values can be provided with comma seperated strings
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='status'>
            /// Status values that need to be considered for filter
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IList<Pet>> FindPetsByStatusAsync( this ISwaggerPetstoreV2 operations, IList<string> status, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IList<Pet>> result = await operations.FindPetsByStatusWithOperationResponseAsync(status, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
            /// tag3 for testing.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='tags'>
            /// Tags to filter by
            /// </param>
            public static IList<Pet> FindPetsByTags(this ISwaggerPetstoreV2 operations, IList<string> tags)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).FindPetsByTagsAsync(tags), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Muliple tags can be provided with comma seperated strings. Use tag1, tag2,
            /// tag3 for testing.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='tags'>
            /// Tags to filter by
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IList<Pet>> FindPetsByTagsAsync( this ISwaggerPetstoreV2 operations, IList<string> tags, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IList<Pet>> result = await operations.FindPetsByTagsWithOperationResponseAsync(tags, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// Returns a single pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='petId'>
            /// Id of pet to return
            /// </param>
            public static Pet GetPetById(this ISwaggerPetstoreV2 operations, long? petId)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).GetPetByIdAsync(petId), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Returns a single pet
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='petId'>
            /// Id of pet to return
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Pet> GetPetByIdAsync( this ISwaggerPetstoreV2 operations, long? petId, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Pet> result = await operations.GetPetByIdWithOperationResponseAsync(petId, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='petId'>
            /// Id of pet that needs to be updated
            /// </param>
            /// <param name='name'>
            /// Updated name of the pet
            /// </param>
            /// <param name='status'>
            /// Updated status of the pet
            /// </param>
            public static void UpdatePetWithForm(this ISwaggerPetstoreV2 operations, long? petId, string name = default(string), string status = default(string))
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).UpdatePetWithFormAsync(petId, name, status), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
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
            public static async Task UpdatePetWithFormAsync( this ISwaggerPetstoreV2 operations, long? petId, string name = default(string), string status = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.UpdatePetWithFormWithOperationResponseAsync(petId, name, status, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='apiKey'>
            /// </param>
            /// <param name='petId'>
            /// Pet id to delete
            /// </param>
            public static void DeletePet(this ISwaggerPetstoreV2 operations, long? petId, string apiKey = default(string))
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).DeletePetAsync(petId, apiKey), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='apiKey'>
            /// </param>
            /// <param name='petId'>
            /// Pet id to delete
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeletePetAsync( this ISwaggerPetstoreV2 operations, long? petId, string apiKey = default(string), CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeletePetWithOperationResponseAsync(petId, apiKey, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// Returns a map of status codes to quantities
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static IDictionary<string, int?> GetInventory(this ISwaggerPetstoreV2 operations)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).GetInventoryAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Returns a map of status codes to quantities
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<IDictionary<string, int?>> GetInventoryAsync( this ISwaggerPetstoreV2 operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<IDictionary<string, int?>> result = await operations.GetInventoryWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// order placed for purchasing the pet
            /// </param>
            public static Order PlaceOrder(this ISwaggerPetstoreV2 operations, Order body)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).PlaceOrderAsync(body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// order placed for purchasing the pet
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Order> PlaceOrderAsync( this ISwaggerPetstoreV2 operations, Order body, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Order> result = await operations.PlaceOrderWithOperationResponseAsync(body, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other
            /// values will generated exceptions
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='orderId'>
            /// Id of pet that needs to be fetched
            /// </param>
            public static Order GetOrderById(this ISwaggerPetstoreV2 operations, string orderId)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).GetOrderByIdAsync(orderId), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// For valid response try integer IDs with value &lt;= 5 or &gt; 10. Other
            /// values will generated exceptions
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='orderId'>
            /// Id of pet that needs to be fetched
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<Order> GetOrderByIdAsync( this ISwaggerPetstoreV2 operations, string orderId, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<Order> result = await operations.GetOrderByIdWithOperationResponseAsync(orderId, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// For valid response try integer IDs with value &lt; 1000. Anything above
            /// 1000 or nonintegers will generate API errors
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='orderId'>
            /// Id of the order that needs to be deleted
            /// </param>
            public static void DeleteOrder(this ISwaggerPetstoreV2 operations, string orderId)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).DeleteOrderAsync(orderId), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// For valid response try integer IDs with value &lt; 1000. Anything above
            /// 1000 or nonintegers will generate API errors
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='orderId'>
            /// Id of the order that needs to be deleted
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteOrderAsync( this ISwaggerPetstoreV2 operations, string orderId, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteOrderWithOperationResponseAsync(orderId, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// This can only be done by the logged in user.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// Created user object
            /// </param>
            public static void CreateUser(this ISwaggerPetstoreV2 operations, User body)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).CreateUserAsync(body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// This can only be done by the logged in user.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// Created user object
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task CreateUserAsync( this ISwaggerPetstoreV2 operations, User body, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.CreateUserWithOperationResponseAsync(body, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            public static void CreateUsersWithArrayInput(this ISwaggerPetstoreV2 operations, IList<User> body)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).CreateUsersWithArrayInputAsync(body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task CreateUsersWithArrayInputAsync( this ISwaggerPetstoreV2 operations, IList<User> body, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.CreateUsersWithArrayInputWithOperationResponseAsync(body, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            public static void CreateUsersWithListInput(this ISwaggerPetstoreV2 operations, IList<User> body)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).CreateUsersWithListInputAsync(body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='body'>
            /// List of user object
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task CreateUsersWithListInputAsync( this ISwaggerPetstoreV2 operations, IList<User> body, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.CreateUsersWithListInputWithOperationResponseAsync(body, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// The user name for login
            /// </param>
            /// <param name='password'>
            /// The password for login in clear text
            /// </param>
            public static string LoginUser(this ISwaggerPetstoreV2 operations, string username, string password)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).LoginUserAsync(username, password), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// The user name for login
            /// </param>
            /// <param name='password'>
            /// The password for login in clear text
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<string> LoginUserAsync( this ISwaggerPetstoreV2 operations, string username, string password, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<string> result = await operations.LoginUserWithOperationResponseAsync(username, password, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            public static void LogoutUser(this ISwaggerPetstoreV2 operations)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).LogoutUserAsync(), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task LogoutUserAsync( this ISwaggerPetstoreV2 operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.LogoutUserWithOperationResponseAsync(cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// The name that needs to be fetched. Use user1 for testing.
            /// </param>
            public static User GetUserByName(this ISwaggerPetstoreV2 operations, string username)
            {
                return Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).GetUserByNameAsync(username), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// The name that needs to be fetched. Use user1 for testing.
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task<User> GetUserByNameAsync( this ISwaggerPetstoreV2 operations, string username, CancellationToken cancellationToken = default(CancellationToken))
            {
                HttpOperationResponse<User> result = await operations.GetUserByNameWithOperationResponseAsync(username, cancellationToken).ConfigureAwait(false);
                return result.Body;
            }

            /// <summary>
            /// This can only be done by the logged in user.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// name that need to be deleted
            /// </param>
            /// <param name='body'>
            /// Updated user object
            /// </param>
            public static void UpdateUser(this ISwaggerPetstoreV2 operations, string username, User body)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).UpdateUserAsync(username, body), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// This can only be done by the logged in user.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// name that need to be deleted
            /// </param>
            /// <param name='body'>
            /// Updated user object
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task UpdateUserAsync( this ISwaggerPetstoreV2 operations, string username, User body, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.UpdateUserWithOperationResponseAsync(username, body, cancellationToken).ConfigureAwait(false);
            }

            /// <summary>
            /// This can only be done by the logged in user.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// The name that needs to be deleted
            /// </param>
            public static void DeleteUser(this ISwaggerPetstoreV2 operations, string username)
            {
                Task.Factory.StartNew(s => ((ISwaggerPetstoreV2)s).DeleteUserAsync(username), operations, CancellationToken.None, TaskCreationOptions.None, TaskScheduler.Default).Unwrap().GetAwaiter().GetResult();
            }

            /// <summary>
            /// This can only be done by the logged in user.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method
            /// </param>
            /// <param name='username'>
            /// The name that needs to be deleted
            /// </param>
            /// <param name='cancellationToken'>
            /// Cancellation token.
            /// </param>
            public static async Task DeleteUserAsync( this ISwaggerPetstoreV2 operations, string username, CancellationToken cancellationToken = default(CancellationToken))
            {
                await operations.DeleteUserWithOperationResponseAsync(username, cancellationToken).ConfigureAwait(false);
            }

    }
}
