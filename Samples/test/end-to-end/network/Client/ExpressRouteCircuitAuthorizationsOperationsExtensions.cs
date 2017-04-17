// Code generated by Microsoft (R) AutoRest Code Generator 1.0.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace applicationGateway
{
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for ExpressRouteCircuitAuthorizationsOperations.
    /// </summary>
    public static partial class ExpressRouteCircuitAuthorizationsOperationsExtensions
    {
            /// <summary>
            /// Deletes the specified authorization from the specified express route
            /// circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            public static void Delete(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName)
            {
                operations.DeleteAsync(resourceGroupName, circuitName, authorizationName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes the specified authorization from the specified express route
            /// circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task DeleteAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.DeleteWithHttpMessagesAsync(resourceGroupName, circuitName, authorizationName, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Gets the specified authorization from the specified express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            public static ExpressRouteCircuitAuthorization Get(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName)
            {
                return operations.GetAsync(resourceGroupName, circuitName, authorizationName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets the specified authorization from the specified express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ExpressRouteCircuitAuthorization> GetAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetWithHttpMessagesAsync(resourceGroupName, circuitName, authorizationName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Creates or updates an authorization in the specified express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='authorizationParameters'>
            /// Parameters supplied to the create or update express route circuit
            /// authorization operation.
            /// </param>
            public static ExpressRouteCircuitAuthorization CreateOrUpdate(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, ExpressRouteCircuitAuthorization authorizationParameters)
            {
                return operations.CreateOrUpdateAsync(resourceGroupName, circuitName, authorizationName, authorizationParameters).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates or updates an authorization in the specified express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='authorizationParameters'>
            /// Parameters supplied to the create or update express route circuit
            /// authorization operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ExpressRouteCircuitAuthorization> CreateOrUpdateAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, ExpressRouteCircuitAuthorization authorizationParameters, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateOrUpdateWithHttpMessagesAsync(resourceGroupName, circuitName, authorizationName, authorizationParameters, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Gets all authorizations in an express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the circuit.
            /// </param>
            public static IPage<ExpressRouteCircuitAuthorization> List(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName)
            {
                return operations.ListAsync(resourceGroupName, circuitName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets all authorizations in an express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the circuit.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IPage<ExpressRouteCircuitAuthorization>> ListAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListWithHttpMessagesAsync(resourceGroupName, circuitName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Deletes the specified authorization from the specified express route
            /// circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            public static void BeginDelete(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName)
            {
                operations.BeginDeleteAsync(resourceGroupName, circuitName, authorizationName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes the specified authorization from the specified express route
            /// circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task BeginDeleteAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.BeginDeleteWithHttpMessagesAsync(resourceGroupName, circuitName, authorizationName, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Creates or updates an authorization in the specified express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='authorizationParameters'>
            /// Parameters supplied to the create or update express route circuit
            /// authorization operation.
            /// </param>
            public static ExpressRouteCircuitAuthorization BeginCreateOrUpdate(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, ExpressRouteCircuitAuthorization authorizationParameters)
            {
                return operations.BeginCreateOrUpdateAsync(resourceGroupName, circuitName, authorizationName, authorizationParameters).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates or updates an authorization in the specified express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='circuitName'>
            /// The name of the express route circuit.
            /// </param>
            /// <param name='authorizationName'>
            /// The name of the authorization.
            /// </param>
            /// <param name='authorizationParameters'>
            /// Parameters supplied to the create or update express route circuit
            /// authorization operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ExpressRouteCircuitAuthorization> BeginCreateOrUpdateAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string resourceGroupName, string circuitName, string authorizationName, ExpressRouteCircuitAuthorization authorizationParameters, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.BeginCreateOrUpdateWithHttpMessagesAsync(resourceGroupName, circuitName, authorizationName, authorizationParameters, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Gets all authorizations in an express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='nextPageLink'>
            /// The NextLink from the previous successful call to List operation.
            /// </param>
            public static IPage<ExpressRouteCircuitAuthorization> ListNext(this IExpressRouteCircuitAuthorizationsOperations operations, string nextPageLink)
            {
                return operations.ListNextAsync(nextPageLink).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets all authorizations in an express route circuit.
            /// </summary>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='nextPageLink'>
            /// The NextLink from the previous successful call to List operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<IPage<ExpressRouteCircuitAuthorization>> ListNextAsync(this IExpressRouteCircuitAuthorizationsOperations operations, string nextPageLink, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListNextWithHttpMessagesAsync(nextPageLink, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
