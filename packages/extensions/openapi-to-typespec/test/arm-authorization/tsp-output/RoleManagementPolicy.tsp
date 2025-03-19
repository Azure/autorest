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
 * Role management policy
 */
@extensionResource
model RoleManagementPolicy
  is Azure.ResourceManager.ExtensionResource<RoleManagementPolicyProperties> {
  ...ResourceNameParameter<
    Resource = RoleManagementPolicy,
    KeyName = "roleManagementPolicyName",
    SegmentName = "roleManagementPolicies",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RoleManagementPolicies {
  /**
   * Get the specified role management policy for a resource scope
   */
  get is ArmResourceRead<
    RoleManagementPolicy,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role management policy.
       */
      @path
      scope: string;

      /**
       * The name (guid) of the role management policy to get.
       */
      @path
      roleManagementPolicyName: string;
    }
  >;

  /**
   * Update a role management policy
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    RoleManagementPolicy,
    PatchModel = RoleManagementPolicy,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role management policy to upsert.
       */
      @path
      scope: string;

      /**
       * The name (guid) of the role management policy to upsert.
       */
      @path
      roleManagementPolicyName: string;
    }
  >;

  /**
   * Gets role management policies for a resource scope.
   */
  listForScope is ArmResourceListByParent<
    RoleManagementPolicy,
    BaseParameters = Azure.ResourceManager.Foundations.ExtensionBaseParameters,
    Parameters = {
      /**
       * The scope of the role management policy.
       */
      @path
      scope: string;
    }
  >;
}

@@doc(RoleManagementPolicy.name,
  "The name (guid) of the role management policy to get."
);
@@doc(RoleManagementPolicy.properties, "Role management policy properties.");
@@doc(RoleManagementPolicies.update::parameters.properties,
  "Parameters for the role management policy."
);
