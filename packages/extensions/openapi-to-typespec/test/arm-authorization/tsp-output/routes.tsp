// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Authorization;

interface ClassicAdministratorsOperations {
  /**
   * Gets service administrator, account administrator, and co-administrators for the subscription.
   */
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/classicAdministrators")
  @get
  list(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<ClassicAdministratorListResult> | ErrorResponse;
}

interface GlobalAdministratorOperations {
  /**
   * Elevates access for a Global Administrator.
   */
  @route("/providers/Microsoft.Authorization/elevateAccess")
  @post
  elevateAccess(...ApiVersionParameter): ArmResponse<void> | ErrorResponse;
}

interface AzurePermissionsForResourceGroupOperations {
  /**
   * Gets all permissions the caller has for a resource group.
   */
  @route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Authorization/permissions")
  @get
  list(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,
    ...SubscriptionIdParameter,
  ): ArmResponse<PermissionGetResult> | ErrorResponse;
}

interface AzurePermissionsForResourceOperations {
  /**
   * Gets all permissions the caller has for a resource.
   */
  @route("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/permissions")
  @get
  list(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The namespace of the resource provider.
     */
    @path
    resourceProviderNamespace: string,

    /**
     * The parent resource identity.
     */
    @path
    parentResourcePath: string,

    /**
     * The resource type of the resource.
     */
    @path
    resourceType: string,

    /**
     * The name of the resource to get the permissions for.
     */
    @path
    resourceName: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<PermissionGetResult> | ErrorResponse;
}

interface EligibleChildResourcesOperations {
  /**
   * Get the child resources of a resource on which user has eligible access
   */
  @route("/{scope}/providers/Microsoft.Authorization/eligibleChildResources")
  @get
  get(
    ...ApiVersionParameter,

    /**
     * The scope of the role management policy.
     */
    @path
    scope: string,

    /**
     * The filter to apply on the operation. Use $filter=resourceType+eq+'Subscription' to filter on only resource of type = 'Subscription'. Use $filter=resourceType+eq+'subscription'+or+resourceType+eq+'resourcegroup' to filter on resource of type = 'Subscription' or 'ResourceGroup'
     */
    @query("$filter")
    $filter?: string,
  ): ArmResponse<EligibleChildResourcesListResult> | ErrorResponse;
}
