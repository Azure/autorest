import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./DenyAssignment.tsp";
import "./ProviderOperationsMetadata.tsp";
import "./RoleAssignment.tsp";
import "./RoleDefinition.tsp";
import "./RoleAssignmentSchedule.tsp";
import "./RoleAssignmentScheduleInstance.tsp";
import "./RoleAssignmentScheduleRequest.tsp";
import "./RoleEligibilitySchedule.tsp";
import "./RoleEligibilityScheduleInstance.tsp";
import "./RoleEligibilityScheduleRequest.tsp";
import "./RoleManagementPolicy.tsp";
import "./RoleManagementPolicyAssignment.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * Role based access control provides you a way to apply granular level policy administration down to individual resources or resource groups. These operations enable you to manage role definitions and role assignments. A role definition describes the set of actions that can be performed on resources. A role assignment grants access to Azure Active Directory users.
 */
@armProviderNamespace
@useAuth(AadOauth2Auth<["user_impersonation"]>)
@service({
  title: "AuthorizationManagementClient",
})
@versioned(Versions)
// FIXME: Common type version v2 is not supported for now.
// @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v2)
namespace Azure.ResourceManager.Authorization;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2015-07-01 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2015_07_01: "2015-07-01",

  /**
   * The 2022-04-01 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_04_01: "2022-04-01",

  /**
   * The 2020-10-01 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2020_10_01: "2020-10-01",
}
