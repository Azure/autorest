import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Authorization;
/**
 * Role Assignments
 */
model RoleAssignment
  is Azure.ResourceManager.ExtensionResource<RoleAssignmentProperties> {
  ...ResourceNameParameter<
    Resource = RoleAssignment,
    KeyName = "roleAssignmentName",
    SegmentName = "roleAssignments",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleAssignments {
  /**
   * Get a role assignment by scope and name.
   */
  get is ArmResourceRead<
    RoleAssignment,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the operation or resource. Valid scopes are: subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
       */
      @path
      scope: string;

      /**
       * The name of the role assignment. It can be any valid GUID.
       */
      @path
      roleAssignmentName: string;

      /**
       * Tenant ID for cross-tenant request
       */
      @query("tenantId")
      tenantId?: string;
    }
  >;

  /**
   * Create or update a role assignment by scope and name.
   */
  create is ArmResourceCreateOrReplaceSync<
    RoleAssignment,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the operation or resource. Valid scopes are: subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
       */
      @path
      scope: string;

      /**
       * The name of the role assignment. It can be any valid GUID.
       */
      @path
      roleAssignmentName: string;
    }
  >;

  /**
   * Delete a role assignment by scope and name.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteSync<
    RoleAssignment,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the operation or resource. Valid scopes are: subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
       */
      @path
      scope: string;

      /**
       * The name of the role assignment. It can be any valid GUID.
       */
      @path
      roleAssignmentName: string;

      /**
       * Tenant ID for cross-tenant request
       */
      @query("tenantId")
      tenantId?: string;
    },
    Response = ArmResponse<RoleAssignment> | ArmDeletedNoContentResponse
  >;

  /**
   * List all role assignments that apply to a scope.
   */
  listForScope is ArmResourceListByParent<
    RoleAssignment,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the operation or resource. Valid scopes are: subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
       */
      @path
      scope: string;

      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Tenant ID for cross-tenant request
       */
      @query("tenantId")
      tenantId?: string;

      /**
       * The skipToken to apply on the operation. Use $skipToken={skiptoken} to return paged role assignments following the skipToken passed. Only supported on provider level calls.
       */
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@doc(RoleAssignment.name,
  "The name of the role assignment. It can be any valid GUID."
);
@@doc(RoleAssignment.properties, "Role assignment properties.");
@@doc(RoleAssignments.create::parameters.resource,
  "Parameters for the role assignment."
);
