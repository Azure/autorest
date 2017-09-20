// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute
{
    using Models;
    using System.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Extension methods for ContainerServices.
    /// </summary>
    public static partial class ContainerServicesExtensions
    {
            /// <summary>
            /// Gets a list of container services in the specified subscription.
            /// </summary>
            /// <remarks>
            /// Gets a list of container services in the specified subscription. The
            /// operation returns properties of each container service including state,
            /// orchestrator, number of masters and agents, and FQDNs of masters and
            /// agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            public static ContainerServiceListResult List(this IContainerServices operations)
            {
                return operations.ListAsync().GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets a list of container services in the specified subscription.
            /// </summary>
            /// <remarks>
            /// Gets a list of container services in the specified subscription. The
            /// operation returns properties of each container service including state,
            /// orchestrator, number of masters and agents, and FQDNs of masters and
            /// agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ContainerServiceListResult> ListAsync(this IContainerServices operations, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListWithHttpMessagesAsync(null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Creates or updates a container service.
            /// </summary>
            /// <remarks>
            /// Creates or updates a container service with the specified configuration of
            /// orchestrator, masters, and agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='containerServiceName'>
            /// The name of the container service in the specified subscription and
            /// resource group.
            /// </param>
            /// <param name='parameters'>
            /// Parameters supplied to the Create or Update a Container Service operation.
            /// </param>
            public static ContainerService CreateOrUpdate(this IContainerServices operations, string resourceGroupName, string containerServiceName, ContainerService parameters)
            {
                return operations.CreateOrUpdateAsync(resourceGroupName, containerServiceName, parameters).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Creates or updates a container service.
            /// </summary>
            /// <remarks>
            /// Creates or updates a container service with the specified configuration of
            /// orchestrator, masters, and agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='containerServiceName'>
            /// The name of the container service in the specified subscription and
            /// resource group.
            /// </param>
            /// <param name='parameters'>
            /// Parameters supplied to the Create or Update a Container Service operation.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ContainerService> CreateOrUpdateAsync(this IContainerServices operations, string resourceGroupName, string containerServiceName, ContainerService parameters, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.CreateOrUpdateWithHttpMessagesAsync(resourceGroupName, containerServiceName, parameters, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Gets the properties of the specified container service.
            /// </summary>
            /// <remarks>
            /// Gets the properties of the specified container service in the specified
            /// subscription and resource group. The operation returns the properties
            /// including state, orchestrator, number of masters and agents, and FQDNs of
            /// masters and agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='containerServiceName'>
            /// The name of the container service in the specified subscription and
            /// resource group.
            /// </param>
            public static ContainerService Get(this IContainerServices operations, string resourceGroupName, string containerServiceName)
            {
                return operations.GetAsync(resourceGroupName, containerServiceName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets the properties of the specified container service.
            /// </summary>
            /// <remarks>
            /// Gets the properties of the specified container service in the specified
            /// subscription and resource group. The operation returns the properties
            /// including state, orchestrator, number of masters and agents, and FQDNs of
            /// masters and agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='containerServiceName'>
            /// The name of the container service in the specified subscription and
            /// resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ContainerService> GetAsync(this IContainerServices operations, string resourceGroupName, string containerServiceName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.GetWithHttpMessagesAsync(resourceGroupName, containerServiceName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

            /// <summary>
            /// Deletes the specified container service.
            /// </summary>
            /// <remarks>
            /// Deletes the specified container service in the specified subscription and
            /// resource group. The operation does not delete other resources created as
            /// part of creating a container service, including storage accounts, VMs, and
            /// availability sets. All the other resources created with the container
            /// service are part of the same resource group and can be deleted
            /// individually.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='containerServiceName'>
            /// The name of the container service in the specified subscription and
            /// resource group.
            /// </param>
            public static void Delete(this IContainerServices operations, string resourceGroupName, string containerServiceName)
            {
                operations.DeleteAsync(resourceGroupName, containerServiceName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Deletes the specified container service.
            /// </summary>
            /// <remarks>
            /// Deletes the specified container service in the specified subscription and
            /// resource group. The operation does not delete other resources created as
            /// part of creating a container service, including storage accounts, VMs, and
            /// availability sets. All the other resources created with the container
            /// service are part of the same resource group and can be deleted
            /// individually.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='containerServiceName'>
            /// The name of the container service in the specified subscription and
            /// resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task DeleteAsync(this IContainerServices operations, string resourceGroupName, string containerServiceName, CancellationToken cancellationToken = default(CancellationToken))
            {
                (await operations.DeleteWithHttpMessagesAsync(resourceGroupName, containerServiceName, null, cancellationToken).ConfigureAwait(false)).Dispose();
            }

            /// <summary>
            /// Gets a list of container services in the specified resource group.
            /// </summary>
            /// <remarks>
            /// Gets a list of container services in the specified subscription and
            /// resource group. The operation returns properties of each container service
            /// including state, orchestrator, number of masters and agents, and FQDNs of
            /// masters and agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            public static ContainerServiceListResult ListByResourceGroup(this IContainerServices operations, string resourceGroupName)
            {
                return operations.ListByResourceGroupAsync(resourceGroupName).GetAwaiter().GetResult();
            }

            /// <summary>
            /// Gets a list of container services in the specified resource group.
            /// </summary>
            /// <remarks>
            /// Gets a list of container services in the specified subscription and
            /// resource group. The operation returns properties of each container service
            /// including state, orchestrator, number of masters and agents, and FQDNs of
            /// masters and agents.
            /// </remarks>
            /// <param name='operations'>
            /// The operations group for this extension method.
            /// </param>
            /// <param name='resourceGroupName'>
            /// The name of the resource group.
            /// </param>
            /// <param name='cancellationToken'>
            /// The cancellation token.
            /// </param>
            public static async Task<ContainerServiceListResult> ListByResourceGroupAsync(this IContainerServices operations, string resourceGroupName, CancellationToken cancellationToken = default(CancellationToken))
            {
                using (var _result = await operations.ListByResourceGroupWithHttpMessagesAsync(resourceGroupName, null, cancellationToken).ConfigureAwait(false))
                {
                    return _result.Body;
                }
            }

    }
}
