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
 * Deny Assignment
 */
model DenyAssignment
  is Azure.ResourceManager.ExtensionResource<DenyAssignmentProperties> {
  ...ResourceNameParameter<
    Resource = DenyAssignment,
    KeyName = "denyAssignmentId",
    SegmentName = "denyAssignments",
    NamePattern = ""
  >;
}

@armResourceOperations
interface DenyAssignments {
  /**
   * Get the specified deny assignment.
   */
  get is ArmResourceRead<
    DenyAssignment,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters
  >;

  /**
   * Gets deny assignments for a resource.
   */
  listForResource is ArmResourceListByParent<
    DenyAssignment,
    Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      ...SubscriptionIdParameter;
      ...ResourceGroupParameter;

      /**
       * The namespace of the resource provider.
       */
      @path
      resourceProviderNamespace: string;

      /**
       * The parent resource identity.
       */
      @path
      parentResourcePath: string;

      /**
       * The resource type of the resource.
       */
      @path
      resourceType: string;

      /**
       * The name of the resource to get deny assignments for.
       */
      @path
      resourceName: string;

      /**
       * The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}

@@doc(DenyAssignment.name, "The ID of the deny assignment to get.");
@@doc(DenyAssignment.properties, "Deny assignment properties.");
