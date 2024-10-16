import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@typespec/openapi";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.Authorization;

/**
 * The principal type of the assigned principal ID.
 */
union PrincipalType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  User: "User",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Group: "Group",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ServicePrincipal: "ServicePrincipal",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ForeignGroup: "ForeignGroup",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Device: "Device",
}

/**
 * The role type.
 */
union RoleType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  BuiltInRole: "BuiltInRole",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  CustomRole: "CustomRole",
}

/**
 * Assignment type of the role assignment schedule
 */
union AssignmentType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Activated: "Activated",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Assigned: "Assigned",
}

/**
 * Membership type of the role assignment schedule
 */
union RoleManagementScheduleMemberType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Inherited: "Inherited",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Direct: "Direct",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Group: "Group",
}

/**
 * The status of the role assignment schedule.
 */
union RoleManagementScheduleStatus {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Accepted: "Accepted",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingEvaluation: "PendingEvaluation",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Granted: "Granted",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Denied: "Denied",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingProvisioning: "PendingProvisioning",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Provisioned: "Provisioned",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingRevocation: "PendingRevocation",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Revoked: "Revoked",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Canceled: "Canceled",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Failed: "Failed",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingApprovalProvisioning: "PendingApprovalProvisioning",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingApproval: "PendingApproval",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  FailedAsResourceIsLocked: "FailedAsResourceIsLocked",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingAdminDecision: "PendingAdminDecision",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminApproved: "AdminApproved",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminDenied: "AdminDenied",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  TimedOut: "TimedOut",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ProvisioningStarted: "ProvisioningStarted",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Invalid: "Invalid",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingScheduleCreation: "PendingScheduleCreation",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  ScheduleCreated: "ScheduleCreated",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  PendingExternalProvisioning: "PendingExternalProvisioning",
}

/**
 * Type of the scope.
 */
union ScopeType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  subscription: "subscription",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  managementgroup: "managementgroup",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  resourcegroup: "resourcegroup",
}

/**
 * The type of the role assignment schedule request. Eg: SelfActivate, AdminAssign etc
 */
union RoleManagementScheduleRequestType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminAssign: "AdminAssign",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminRemove: "AdminRemove",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminUpdate: "AdminUpdate",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminExtend: "AdminExtend",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AdminRenew: "AdminRenew",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  SelfActivate: "SelfActivate",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  SelfDeactivate: "SelfDeactivate",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  SelfExtend: "SelfExtend",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  SelfRenew: "SelfRenew",
}

/**
 * Type of the role assignment schedule expiration
 */
union RoleManagementScheduleExpirationType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AfterDuration: "AfterDuration",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  AfterDateTime: "AfterDateTime",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  NoExpiration: "NoExpiration",
}

/**
 * The type of rule
 */
union RoleManagementPolicyRuleType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  RoleManagementPolicyApprovalRule: "RoleManagementPolicyApprovalRule",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  RoleManagementPolicyAuthenticationContextRule: "RoleManagementPolicyAuthenticationContextRule",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  RoleManagementPolicyEnablementRule: "RoleManagementPolicyEnablementRule",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  RoleManagementPolicyExpirationRule: "RoleManagementPolicyExpirationRule",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  RoleManagementPolicyNotificationRule: "RoleManagementPolicyNotificationRule",
}

/**
 * The assignment level to which rule is applied.
 */
union RoleManagementAssignmentLevel {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Assignment: "Assignment",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Eligibility: "Eligibility",
}

/**
 * The type of rule
 */
union ApprovalMode {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  SingleStage: "SingleStage",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Serial: "Serial",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Parallel: "Parallel",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  NoApproval: "NoApproval",
}

/**
 * The type of user.
 */
union UserType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  User: "User",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Group: "Group",
}

/**
 * The type of enablement rule
 */
union EnablementRules {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  MultiFactorAuthentication: "MultiFactorAuthentication",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Justification: "Justification",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Ticketing: "Ticketing",
}

/**
 * The type of notification.
 */
union NotificationDeliveryMechanism {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Email: "Email",
}

/**
 * The notification level.
 */
union NotificationLevel {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  None: "None",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Critical: "Critical",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  All: "All",
}

/**
 * The recipient type.
 */
union RecipientType {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Requestor: "Requestor",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Approver: "Approver",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Admin: "Admin",
}

/**
 * ClassicAdministrator list result information.
 */
model ClassicAdministratorListResult is Azure.Core.Page<ClassicAdministrator>;

/**
 * Classic Administrators
 */
model ClassicAdministrator {
  /**
   * The ID of the administrator.
   */
  id?: string;

  /**
   * The name of the administrator.
   */
  name?: string;

  /**
   * The type of the administrator.
   */
  type?: string;

  /**
   * Properties for the classic administrator.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ClassicAdministratorProperties;
}

/**
 * Classic Administrator properties.
 */
model ClassicAdministratorProperties {
  /**
   * The email address of the administrator.
   */
  emailAddress?: string;

  /**
   * The role of the administrator.
   */
  role?: string;
}

/**
 * Deny assignment list operation result.
 */
model DenyAssignmentListResult is Azure.Core.Page<DenyAssignment>;

/**
 * Deny assignment properties.
 */
model DenyAssignmentProperties {
  /**
   * The display name of the deny assignment.
   */
  denyAssignmentName?: string;

  /**
   * The description of the deny assignment.
   */
  description?: string;

  /**
   * An array of permissions that are denied by the deny assignment.
   */
  @OpenAPI.extension("x-ms-identifiers", [])
  permissions?: DenyAssignmentPermission[];

  /**
   * The deny assignment scope.
   */
  scope?: string;

  /**
   * Determines if the deny assignment applies to child scopes. Default value is false.
   */
  doNotApplyToChildScopes?: boolean;

  /**
   * Array of principals to which the deny assignment applies.
   */
  principals?: Principal[];

  /**
   * Array of principals to which the deny assignment does not apply.
   */
  excludePrincipals?: Principal[];

  /**
   * Specifies whether this deny assignment was created by Azure and cannot be edited or deleted.
   */
  isSystemProtected?: boolean;
}

/**
 * Deny assignment permissions.
 */
model DenyAssignmentPermission {
  /**
   * Actions to which the deny assignment does not grant access.
   */
  actions?: string[];

  /**
   * Actions to exclude from that the deny assignment does not grant access.
   */
  notActions?: string[];

  /**
   * Data actions to which the deny assignment does not grant access.
   */
  dataActions?: string[];

  /**
   * Data actions to exclude from that the deny assignment does not grant access.
   */
  notDataActions?: string[];

  /**
   * The conditions on the Deny assignment permission. This limits the resources it applies to.
   */
  condition?: string;

  /**
   * Version of the condition.
   */
  conditionVersion?: string;
}

/**
 * The name of the entity last modified it
 */
model Principal {
  /**
   * The id of the principal made changes
   */
  id?: string;

  /**
   * The name of the principal made changes
   */
  displayName?: string;

  /**
   * Type of the principal.
   */
  @encodedName("application/json", "type")
  principalType?: PrincipalType;

  /**
   * Email of principal
   */
  email?: string;
}

/**
 * Resource Type
 */
model AuthorizationProviderResourceType {
  /**
   * The resource type name.
   */
  name?: string;

  /**
   * The resource type display name.
   */
  displayName?: string;

  /**
   * The resource type operations.
   */
  @OpenAPI.extension("x-ms-identifiers", [])
  operations?: ProviderOperation[];
}

/**
 * Operation
 */
model ProviderOperation {
  /**
   * The operation name.
   */
  name?: string;

  /**
   * The operation display name.
   */
  displayName?: string;

  /**
   * The operation description.
   */
  description?: string;

  /**
   * The operation origin.
   */
  origin?: string;

  /**
   * The operation properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: Record<unknown>;

  /**
   * The dataAction flag to specify the operation type.
   */
  isDataAction?: boolean;
}

/**
 * Provider operations metadata list
 */
model ProviderOperationsMetadataListResult
  is Azure.Core.Page<ProviderOperationsMetadata>;

/**
 * Role assignment properties.
 */
model RoleAssignmentProperties {
  /**
   * The role assignment scope.
   */
  @visibility("read")
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId: string;

  /**
   * The principal ID.
   */
  principalId: string;

  /**
   * The principal type of the assigned principal ID.
   */
  principalType?: PrincipalType;

  /**
   * Description of role assignment
   */
  description?: string;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently the only accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * Time it was created
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * Time it was updated
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedOn?: utcDateTime;

  /**
   * Id of the user who created the assignment
   */
  @visibility("read")
  createdBy?: string;

  /**
   * Id of the user who updated the assignment
   */
  @visibility("read")
  updatedBy?: string;

  /**
   * Id of the delegated managed identity resource
   */
  delegatedManagedIdentityResourceId?: string;
}

/**
 * Role assignment create parameters.
 */
model RoleAssignmentCreateParameters {
  /**
   * Role assignment properties.
   */
  @extension("x-ms-client-flatten", true)
  properties: RoleAssignmentProperties;
}

/**
 * Role assignment list operation result.
 */
model RoleAssignmentListResult is Azure.Core.Page<RoleAssignment>;

/**
 * Permissions information.
 */
model PermissionGetResult is Azure.Core.Page<Permission>;

/**
 * Role definition permissions.
 */
model Permission {
  /**
   * Allowed actions.
   */
  actions?: string[];

  /**
   * Denied actions.
   */
  notActions?: string[];

  /**
   * Allowed Data actions.
   */
  dataActions?: string[];

  /**
   * Denied Data actions.
   */
  notDataActions?: string[];
}

/**
 * Role definition properties.
 */
model RoleDefinitionProperties {
  /**
   * The role name.
   */
  roleName?: string;

  /**
   * The role definition description.
   */
  description?: string;

  /**
   * The role type.
   */
  @encodedName("application/json", "type")
  roleType?: RoleType;

  /**
   * Role definition permissions.
   */
  @OpenAPI.extension("x-ms-identifiers", [])
  permissions?: Permission[];

  /**
   * Role definition assignable scopes.
   */
  assignableScopes?: string[];
}

/**
 * Role definition list operation result.
 */
model RoleDefinitionListResult is Azure.Core.Page<RoleDefinition>;

/**
 * Eligible child resources list operation result.
 */
model EligibleChildResourcesListResult
  is Azure.Core.Page<EligibleChildResource>;

/**
 * Eligible child resource
 */
model EligibleChildResource {
  /**
   * The resource scope Id.
   */
  @visibility("read")
  id?: string;

  /**
   * The resource name.
   */
  @visibility("read")
  name?: string;

  /**
   * The resource type.
   */
  @visibility("read")
  type?: string;
}

/**
 * An error response from the service.
 */
@error
model CloudError {
  /**
   * An error response from the service.
   */
  error?: CloudErrorBody;
}

/**
 * An error response from the service.
 */
model CloudErrorBody {
  /**
   * An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
   */
  code?: string;

  /**
   * A message describing the error, intended to be suitable for display in a user interface.
   */
  message?: string;
}

/**
 * Role assignment schedule properties with scope.
 */
model RoleAssignmentScheduleProperties {
  /**
   * The role assignment schedule scope.
   */
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId?: string;

  /**
   * The principal ID.
   */
  principalId?: string;

  /**
   * The principal type of the assigned principal ID.
   */
  principalType?: PrincipalType;

  /**
   * The id of roleAssignmentScheduleRequest used to create this roleAssignmentSchedule
   */
  roleAssignmentScheduleRequestId?: string;

  /**
   * The id of roleEligibilitySchedule used to activated this roleAssignmentSchedule
   */
  linkedRoleEligibilityScheduleId?: string;

  /**
   * Assignment type of the role assignment schedule
   */
  assignmentType?: AssignmentType;

  /**
   * Membership type of the role assignment schedule
   */
  memberType?: RoleManagementScheduleMemberType;

  /**
   * The status of the role assignment schedule.
   */
  status?: RoleManagementScheduleStatus;

  /**
   * Start DateTime when role assignment schedule
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * End DateTime when role assignment schedule
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * DateTime when role assignment schedule was created
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * DateTime when role assignment schedule was modified
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedOn?: utcDateTime;

  /**
   * Additional properties of principal, scope and role definition
   */
  expandedProperties?: ExpandedProperties;
}

model ExpandedProperties {
  /**
   * Details of the resource scope
   */
  @extension("x-ms-client-flatten", true)
  scope?: ExpandedPropertiesScope;

  /**
   * Details of role definition
   */
  @extension("x-ms-client-flatten", true)
  roleDefinition?: ExpandedPropertiesRoleDefinition;

  /**
   * Details of the principal
   */
  @extension("x-ms-client-flatten", true)
  principal?: ExpandedPropertiesPrincipal;
}

/**
 * Details of the resource scope
 */
model ExpandedPropertiesScope {
  /**
   * Scope id of the resource
   */
  @encodedName("application/json", "id")
  scopeId?: string;

  /**
   * Display name of the resource
   */
  @encodedName("application/json", "displayName")
  scopeDisplayName?: string;

  /**
   * Type of the scope.
   */
  @encodedName("application/json", "type")
  scopeType?: ScopeType;
}

/**
 * Details of role definition
 */
model ExpandedPropertiesRoleDefinition {
  /**
   * Id of the role definition
   */
  @encodedName("application/json", "id")
  roleDefinitionId?: string;

  /**
   * Display name of the role definition
   */
  @encodedName("application/json", "displayName")
  roleDefinitionDisplayName?: string;

  /**
   * The role type.
   */
  @encodedName("application/json", "type")
  roleType?: RoleType;
}

/**
 * Details of the principal
 */
model ExpandedPropertiesPrincipal {
  /**
   * Id of the principal
   */
  @encodedName("application/json", "id")
  principalId?: string;

  /**
   * Display name of the principal
   */
  @encodedName("application/json", "displayName")
  principalDisplayName?: string;

  /**
   * Email id of the principal
   */
  email?: string;

  /**
   * Type of the principal.
   */
  @encodedName("application/json", "type")
  principalType?: PrincipalType;
}

/**
 * Role assignment schedule list operation result.
 */
model RoleAssignmentScheduleListResult
  is Azure.Core.Page<RoleAssignmentSchedule>;

/**
 * Role assignment schedule instance list operation result.
 */
model RoleAssignmentScheduleInstanceListResult
  is Azure.Core.Page<RoleAssignmentScheduleInstance>;

/**
 * Role assignment schedule properties with scope.
 */
model RoleAssignmentScheduleInstanceProperties {
  /**
   * The role assignment schedule scope.
   */
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId?: string;

  /**
   * The principal ID.
   */
  principalId?: string;

  /**
   * The principal type of the assigned principal ID.
   */
  principalType?: PrincipalType;

  /**
   * Id of the master role assignment schedule
   */
  roleAssignmentScheduleId?: string;

  /**
   * Role Assignment Id in external system
   */
  originRoleAssignmentId?: string;

  /**
   * The status of the role assignment schedule instance.
   */
  status?: RoleManagementScheduleStatus;

  /**
   * The startDateTime of the role assignment schedule instance
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * The endDateTime of the role assignment schedule instance
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  /**
   * roleEligibilityScheduleId used to activate
   */
  linkedRoleEligibilityScheduleId?: string;

  /**
   * roleEligibilityScheduleInstanceId linked to this roleAssignmentScheduleInstance
   */
  linkedRoleEligibilityScheduleInstanceId?: string;

  /**
   * Assignment type of the role assignment schedule
   */
  assignmentType?: AssignmentType;

  /**
   * Membership type of the role assignment schedule
   */
  memberType?: RoleManagementScheduleMemberType;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * DateTime when role assignment schedule was created
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * Additional properties of principal, scope and role definition
   */
  expandedProperties?: ExpandedProperties;
}

/**
 * Role assignment schedule request properties with scope.
 */
model RoleAssignmentScheduleRequestProperties {
  /**
   * The role assignment schedule request scope.
   */
  @visibility("read")
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId: string;

  /**
   * The principal ID.
   */
  principalId: string;

  /**
   * The principal type of the assigned principal ID.
   */
  @visibility("read")
  principalType?: PrincipalType;

  /**
   * The type of the role assignment schedule request. Eg: SelfActivate, AdminAssign etc
   */
  requestType: RoleManagementScheduleRequestType;

  /**
   * The status of the role assignment schedule request.
   */
  @visibility("read")
  status?: RoleManagementScheduleStatus;

  /**
   * The approvalId of the role assignment schedule request.
   */
  @visibility("read")
  approvalId?: string;

  /**
   * The resultant role assignment schedule id or the role assignment schedule id being updated
   */
  targetRoleAssignmentScheduleId?: string;

  /**
   * The role assignment schedule instance id being updated
   */
  targetRoleAssignmentScheduleInstanceId?: string;

  /**
   * Schedule info of the role assignment schedule
   */
  @extension("x-ms-client-flatten", true)
  scheduleInfo?: RoleAssignmentScheduleRequestPropertiesScheduleInfo;

  /**
   * The linked role eligibility schedule id - to activate an eligibility.
   */
  linkedRoleEligibilityScheduleId?: string;

  /**
   * Justification for the role assignment
   */
  justification?: string;

  /**
   * Ticket Info of the role assignment
   */
  ticketInfo?: RoleAssignmentScheduleRequestPropertiesTicketInfo;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * DateTime when role assignment schedule request was created
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * Id of the user who created this request
   */
  @visibility("read")
  requestorId?: string;

  /**
   * Additional properties of principal, scope and role definition
   */
  @visibility("read")
  expandedProperties?: ExpandedProperties;
}

/**
 * Schedule info of the role assignment schedule
 */
model RoleAssignmentScheduleRequestPropertiesScheduleInfo {
  /**
   * Start DateTime of the role assignment schedule.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * Expiration of the role assignment schedule
   */
  @extension("x-ms-client-flatten", true)
  expiration?: RoleAssignmentScheduleRequestPropertiesScheduleInfoExpiration;
}

/**
 * Expiration of the role assignment schedule
 */
model RoleAssignmentScheduleRequestPropertiesScheduleInfoExpiration {
  /**
   * Type of the role assignment schedule expiration
   */
  @encodedName("application/json", "type")
  expirationType?: RoleManagementScheduleExpirationType;

  /**
   * End DateTime of the role assignment schedule.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  /**
   * Duration of the role assignment schedule in TimeSpan.
   */
  duration?: duration;
}

/**
 * Ticket Info of the role assignment
 */
model RoleAssignmentScheduleRequestPropertiesTicketInfo {
  /**
   * Ticket number for the role assignment
   */
  ticketNumber?: string;

  /**
   * Ticket system name for the role assignment
   */
  ticketSystem?: string;
}

/**
 * Role assignment schedule request list operation result.
 */
model RoleAssignmentScheduleRequestListResult
  is Azure.Core.Page<RoleAssignmentScheduleRequest>;

/**
 * Role eligibility schedule properties with scope.
 */
model RoleEligibilityScheduleProperties {
  /**
   * The role eligibility schedule scope.
   */
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId?: string;

  /**
   * The principal ID.
   */
  principalId?: string;

  /**
   * The principal type of the assigned principal ID.
   */
  principalType?: PrincipalType;

  /**
   * The id of roleEligibilityScheduleRequest used to create this roleAssignmentSchedule
   */
  roleEligibilityScheduleRequestId?: string;

  /**
   * Membership type of the role eligibility schedule
   */
  memberType?: RoleManagementScheduleMemberType;

  /**
   * The status of the role eligibility schedule.
   */
  status?: RoleManagementScheduleStatus;

  /**
   * Start DateTime when role eligibility schedule
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * End DateTime when role eligibility schedule
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * DateTime when role eligibility schedule was created
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * DateTime when role eligibility schedule was modified
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedOn?: utcDateTime;

  /**
   * Additional properties of principal, scope and role definition
   */
  expandedProperties?: ExpandedProperties;
}

/**
 * role eligibility schedule list operation result.
 */
model RoleEligibilityScheduleListResult
  is Azure.Core.Page<RoleEligibilitySchedule>;

/**
 * Role eligibility schedule instance list operation result.
 */
model RoleEligibilityScheduleInstanceListResult
  is Azure.Core.Page<RoleEligibilityScheduleInstance>;

/**
 * Role eligibility schedule properties with scope.
 */
model RoleEligibilityScheduleInstanceProperties {
  /**
   * The role eligibility schedule scope.
   */
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId?: string;

  /**
   * The principal ID.
   */
  principalId?: string;

  /**
   * The principal type of the assigned principal ID.
   */
  principalType?: PrincipalType;

  /**
   * Id of the master role eligibility schedule
   */
  roleEligibilityScheduleId?: string;

  /**
   * The status of the role eligibility schedule instance
   */
  status?: RoleManagementScheduleStatus;

  /**
   * The startDateTime of the role eligibility schedule instance
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * The endDateTime of the role eligibility schedule instance
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  /**
   * Membership type of the role eligibility schedule
   */
  memberType?: RoleManagementScheduleMemberType;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * DateTime when role eligibility schedule was created
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * Additional properties of principal, scope and role definition
   */
  expandedProperties?: ExpandedProperties;
}

/**
 * Role eligibility schedule request properties with scope.
 */
model RoleEligibilityScheduleRequestProperties {
  /**
   * The role eligibility schedule request scope.
   */
  @visibility("read")
  scope?: string;

  /**
   * The role definition ID.
   */
  roleDefinitionId: string;

  /**
   * The principal ID.
   */
  principalId: string;

  /**
   * The principal type of the assigned principal ID.
   */
  @visibility("read")
  principalType?: PrincipalType;

  /**
   * The type of the role assignment schedule request. Eg: SelfActivate, AdminAssign etc
   */
  requestType: RoleManagementScheduleRequestType;

  /**
   * The status of the role eligibility schedule request.
   */
  @visibility("read")
  status?: RoleManagementScheduleStatus;

  /**
   * The approvalId of the role eligibility schedule request.
   */
  @visibility("read")
  approvalId?: string;

  /**
   * Schedule info of the role eligibility schedule
   */
  @extension("x-ms-client-flatten", true)
  scheduleInfo?: RoleEligibilityScheduleRequestPropertiesScheduleInfo;

  /**
   * The resultant role eligibility schedule id or the role eligibility schedule id being updated
   */
  targetRoleEligibilityScheduleId?: string;

  /**
   * The role eligibility schedule instance id being updated
   */
  targetRoleEligibilityScheduleInstanceId?: string;

  /**
   * Justification for the role eligibility
   */
  justification?: string;

  /**
   * Ticket Info of the role eligibility
   */
  ticketInfo?: RoleEligibilityScheduleRequestPropertiesTicketInfo;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  /**
   * Version of the condition. Currently accepted value is '2.0'
   */
  conditionVersion?: string;

  /**
   * DateTime when role eligibility schedule request was created
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * Id of the user who created this request
   */
  @visibility("read")
  requestorId?: string;

  /**
   * Additional properties of principal, scope and role definition
   */
  @visibility("read")
  expandedProperties?: ExpandedProperties;
}

/**
 * Schedule info of the role eligibility schedule
 */
model RoleEligibilityScheduleRequestPropertiesScheduleInfo {
  /**
   * Start DateTime of the role eligibility schedule.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * Expiration of the role eligibility schedule
   */
  @extension("x-ms-client-flatten", true)
  expiration?: RoleEligibilityScheduleRequestPropertiesScheduleInfoExpiration;
}

/**
 * Expiration of the role eligibility schedule
 */
model RoleEligibilityScheduleRequestPropertiesScheduleInfoExpiration {
  /**
   * Type of the role eligibility schedule expiration
   */
  @encodedName("application/json", "type")
  expirationType?: RoleManagementScheduleExpirationType;

  /**
   * End DateTime of the role eligibility schedule.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  /**
   * Duration of the role eligibility schedule in TimeSpan.
   */
  duration?: duration;
}

/**
 * Ticket Info of the role eligibility
 */
model RoleEligibilityScheduleRequestPropertiesTicketInfo {
  /**
   * Ticket number for the role eligibility
   */
  ticketNumber?: string;

  /**
   * Ticket system name for the role eligibility
   */
  ticketSystem?: string;
}

/**
 * Role eligibility schedule request list operation result.
 */
model RoleEligibilityScheduleRequestListResult
  is Azure.Core.Page<RoleEligibilityScheduleRequest>;

/**
 * Role management policy properties with scope.
 */
model RoleManagementPolicyProperties {
  /**
   * The role management policy scope.
   */
  scope?: string;

  /**
   * The role management policy display name.
   */
  displayName?: string;

  /**
   * The role management policy description.
   */
  description?: string;

  /**
   * The role management policy is default policy.
   */
  isOrganizationDefault?: boolean;

  /**
   * The name of the entity last modified it
   */
  @visibility("read")
  lastModifiedBy?: Principal;

  /**
   * The last modified date time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The rule applied to the policy.
   */
  rules?: RoleManagementPolicyRule[];

  /**
   * The readonly computed rule applied to the policy.
   */
  @visibility("read")
  effectiveRules?: RoleManagementPolicyRule[];

  /**
   * Additional properties of scope
   */
  @visibility("read")
  policyProperties?: PolicyProperties;
}

/**
 * The role management policy rule.
 */
@discriminator("ruleType")
model RoleManagementPolicyRule {
  /**
   * The id of the rule.
   */
  id?: string;

  /**
   * The target of the current rule.
   */
  target?: RoleManagementPolicyRuleTarget;
}

/**
 * The role management policy rule target.
 */
model RoleManagementPolicyRuleTarget {
  /**
   * The caller of the setting.
   */
  caller?: string;

  /**
   * The type of operation.
   */
  operations?: string[];

  /**
   * The assignment level to which rule is applied.
   */
  level?: RoleManagementAssignmentLevel;

  /**
   * The list of target objects.
   */
  targetObjects?: string[];

  /**
   * The list of inheritable settings.
   */
  inheritableSettings?: string[];

  /**
   * The list of enforced settings.
   */
  enforcedSettings?: string[];
}

/**
 * Expanded info of resource scope
 */
model PolicyProperties {
  /**
   * Details of the resource scope
   */
  @visibility("read")
  @extension("x-ms-client-flatten", true)
  scope?: PolicyPropertiesScope;
}

/**
 * Details of the resource scope
 */
model PolicyPropertiesScope {
  /**
   * Scope id of the resource
   */
  @encodedName("application/json", "id")
  scopeId?: string;

  /**
   * Display name of the resource
   */
  @encodedName("application/json", "displayName")
  scopeDisplayName?: string;

  /**
   * Type of the scope.
   */
  @encodedName("application/json", "type")
  scopeType?: ScopeType;
}

/**
 * Role management policy list operation result.
 */
model RoleManagementPolicyListResult is Azure.Core.Page<RoleManagementPolicy>;

/**
 * Role management policy assignment properties with scope.
 */
model RoleManagementPolicyAssignmentProperties {
  /**
   * The role management policy scope.
   */
  scope?: string;

  /**
   * The role definition of management policy assignment.
   */
  roleDefinitionId?: string;

  /**
   * The policy id role management policy assignment.
   */
  policyId?: string;

  /**
   * The readonly computed rule applied to the policy.
   */
  @visibility("read")
  effectiveRules?: RoleManagementPolicyRule[];

  /**
   * Additional properties of scope, role definition and policy
   */
  @visibility("read")
  policyAssignmentProperties?: PolicyAssignmentProperties;
}

/**
 * Expanded info of resource scope, role definition and policy
 */
model PolicyAssignmentProperties {
  /**
   * Details of the resource scope
   */
  @extension("x-ms-client-flatten", true)
  scope?: PolicyAssignmentPropertiesScope;

  /**
   * Details of role definition
   */
  @extension("x-ms-client-flatten", true)
  roleDefinition?: PolicyAssignmentPropertiesRoleDefinition;

  /**
   * Details of the policy
   */
  @extension("x-ms-client-flatten", true)
  policy?: PolicyAssignmentPropertiesPolicy;
}

/**
 * Details of the resource scope
 */
model PolicyAssignmentPropertiesScope {
  /**
   * Scope id of the resource
   */
  @encodedName("application/json", "id")
  scopeId?: string;

  /**
   * Display name of the resource
   */
  @encodedName("application/json", "displayName")
  scopeDisplayName?: string;

  /**
   * Type of the scope.
   */
  @encodedName("application/json", "type")
  scopeType?: ScopeType;
}

/**
 * Details of role definition
 */
model PolicyAssignmentPropertiesRoleDefinition {
  /**
   * Id of the role definition
   */
  @encodedName("application/json", "id")
  roleDefinitionId?: string;

  /**
   * Display name of the role definition
   */
  @encodedName("application/json", "displayName")
  roleDefinitionDisplayName?: string;

  /**
   * The role type.
   */
  @encodedName("application/json", "type")
  roleType?: RoleType;
}

/**
 * Details of the policy
 */
model PolicyAssignmentPropertiesPolicy {
  /**
   * Id of the policy
   */
  @encodedName("application/json", "id")
  policyId?: string;

  /**
   * The name of the entity last modified it
   */
  @visibility("read")
  lastModifiedBy?: Principal;

  /**
   * The last modified date time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;
}

/**
 * Role management policy assignment list operation result.
 */
model RoleManagementPolicyAssignmentListResult
  is Azure.Core.Page<RoleManagementPolicyAssignment>;

/**
 * Deny Assignments filter
 */
model DenyAssignmentFilter {
  /**
   * Return deny assignment with specified name.
   */
  denyAssignmentName?: string;

  /**
   * Return all deny assignments where the specified principal is listed in the principals list of deny assignments.
   */
  principalId?: string;

  /**
   * Return all deny assignments where the specified principal is listed either in the principals list or exclude principals list of deny assignments.
   */
  gdprExportPrincipalId?: string;
}

/**
 * Failed validation result details
 */
model ValidationResponseErrorInfo {
  /**
   * Error code indicating why validation failed
   */
  @visibility("read")
  code?: string;

  /**
   * Message indicating why validation failed
   */
  @visibility("read")
  message?: string;
}

/**
 * Validation response
 */
model ValidationResponse {
  /**
   * Whether or not validation succeeded
   */
  @visibility("read")
  isValid?: boolean;

  /**
   * Failed validation result details
   */
  errorInfo?: ValidationResponseErrorInfo;
}

/**
 * Role Assignments filter
 */
model RoleAssignmentFilter {
  /**
   * Returns role assignment of the specific principal.
   */
  principalId?: string;
}

/**
 * Role Definitions filter
 */
model RoleDefinitionFilter {
  /**
   * Returns role definition with the specific name.
   */
  roleName?: string;

  /**
   * Returns role definition with the specific type.
   */
  type?: string;
}

/**
 * The role management policy approval rule.
 */
model RoleManagementPolicyApprovalRule extends RoleManagementPolicyRule {
  /**
   * The approval setting
   */
  setting?: ApprovalSettings;

  /**
   * The type of rule
   */
  ruleType: "RoleManagementPolicyApprovalRule";
}

/**
 * The approval settings.
 */
model ApprovalSettings {
  /**
   * Determines whether approval is required or not.
   */
  isApprovalRequired?: boolean;

  /**
   * Determines whether approval is required for assignment extension.
   */
  isApprovalRequiredForExtension?: boolean;

  /**
   * Determine whether requestor justification is required.
   */
  isRequestorJustificationRequired?: boolean;

  /**
   * The type of rule
   */
  approvalMode?: ApprovalMode;

  /**
   * The approval stages of the request.
   */
  @OpenAPI.extension("x-ms-identifiers", [])
  approvalStages?: ApprovalStage[];
}

/**
 * The approval stage.
 */
model ApprovalStage {
  /**
   * The time in days when approval request would be timed out
   */
  approvalStageTimeOutInDays?: int32;

  /**
   * Determines whether approver need to provide justification for his decision.
   */
  isApproverJustificationRequired?: boolean;

  /**
   * The time in minutes when the approval request would be escalated if the primary approver does not approve
   */
  escalationTimeInMinutes?: int32;

  /**
   * The primary approver of the request.
   */
  primaryApprovers?: UserSet[];

  /**
   * The value determine whether escalation feature is enabled.
   */
  isEscalationEnabled?: boolean;

  /**
   * The escalation approver of the request.
   */
  escalationApprovers?: UserSet[];
}

/**
 * The detail of a user.
 */
model UserSet {
  /**
   * The type of user.
   */
  userType?: UserType;

  /**
   * The value indicating whether the user is a backup fallback approver
   */
  isBackup?: boolean;

  /**
   * The object id of the user.
   */
  id?: string;

  /**
   * The description of the user.
   */
  description?: string;
}

/**
 * The role management policy authentication context rule.
 */
model RoleManagementPolicyAuthenticationContextRule
  extends RoleManagementPolicyRule {
  /**
   * The value indicating if rule is enabled.
   */
  isEnabled?: boolean;

  /**
   * The claim value.
   */
  claimValue?: string;

  /**
   * The type of rule
   */
  ruleType: "RoleManagementPolicyAuthenticationContextRule";
}

/**
 * The role management policy enablement rule.
 */
model RoleManagementPolicyEnablementRule extends RoleManagementPolicyRule {
  /**
   * The list of enabled rules.
   */
  enabledRules?: EnablementRules[];

  /**
   * The type of rule
   */
  ruleType: "RoleManagementPolicyEnablementRule";
}

/**
 * The role management policy expiration rule.
 */
model RoleManagementPolicyExpirationRule extends RoleManagementPolicyRule {
  /**
   * The value indicating whether expiration is required.
   */
  isExpirationRequired?: boolean;

  /**
   * The maximum duration of expiration in timespan.
   */
  maximumDuration?: duration;

  /**
   * The type of rule
   */
  ruleType: "RoleManagementPolicyExpirationRule";
}

/**
 * The role management policy notification rule.
 */
model RoleManagementPolicyNotificationRule extends RoleManagementPolicyRule {
  /**
   * The type of notification.
   */
  notificationType?: NotificationDeliveryMechanism;

  /**
   * The notification level.
   */
  notificationLevel?: NotificationLevel;

  /**
   * The recipient type.
   */
  recipientType?: RecipientType;

  /**
   * The list of notification recipients.
   */
  notificationRecipients?: string[];

  /**
   * Determines if the notification will be sent to the recipient type specified in the policy rule.
   */
  isDefaultRecipientsEnabled?: boolean;

  /**
   * The type of rule
   */
  ruleType: "RoleManagementPolicyNotificationRule";
}

/**
 * Role assignment schedule filter
 */
model RoleAssignmentScheduleFilter {
  /**
   * Returns role assignment schedule of the specific principal.
   */
  principalId?: string;

  /**
   * Returns role assignment schedule of the specific role definition.
   */
  roleDefinitionId?: string;

  /**
   * Returns role assignment schedule instances of the specific status.
   */
  status?: string;
}

/**
 * Role assignment schedule instance filter
 */
model RoleAssignmentScheduleInstanceFilter {
  /**
   * Returns role assignment schedule instances of the specific principal.
   */
  principalId?: string;

  /**
   * Returns role assignment schedule instances of the specific role definition.
   */
  roleDefinitionId?: string;

  /**
   * Returns role assignment schedule instances of the specific status.
   */
  status?: string;

  /**
   * Returns role assignment schedule instances belonging to a specific role assignment schedule.
   */
  roleAssignmentScheduleId?: string;
}

/**
 * Role assignment schedule request filter
 */
model RoleAssignmentScheduleRequestFilter {
  /**
   * Returns role assignment requests of the specific principal.
   */
  principalId?: string;

  /**
   * Returns role assignment requests of the specific role definition.
   */
  roleDefinitionId?: string;

  /**
   * Returns role assignment requests created by specific principal.
   */
  requestorId?: string;

  /**
   * Returns role assignment requests of specific status.
   */
  status?: string;
}

/**
 * Role eligibility schedule filter
 */
model RoleEligibilityScheduleFilter {
  /**
   * Returns role eligibility schedule of the specific principal.
   */
  principalId?: string;

  /**
   * Returns role eligibility schedule of the specific role definition.
   */
  roleDefinitionId?: string;

  /**
   * Returns role eligibility schedule of the specific status.
   */
  status?: string;
}

/**
 * Role eligibility schedule instance filter
 */
model RoleEligibilityScheduleInstanceFilter {
  /**
   * Returns role eligibility schedule instances of the specific principal.
   */
  principalId?: string;

  /**
   * Returns role eligibility schedule instances of the specific role definition.
   */
  roleDefinitionId?: string;

  /**
   * Returns role eligibility schedule instances of the specific status.
   */
  status?: string;

  /**
   * Returns role eligibility schedule instances belonging to a specific role eligibility schedule.
   */
  roleEligibilityScheduleId?: string;
}

/**
 * Role eligibility schedule request filter
 */
model RoleEligibilityScheduleRequestFilter {
  /**
   * Returns role eligibility requests of the specific principal.
   */
  principalId?: string;

  /**
   * Returns role eligibility requests of the specific role definition.
   */
  roleDefinitionId?: string;

  /**
   * Returns role eligibility requests created by specific principal.
   */
  requestorId?: string;

  /**
   * Returns role eligibility requests of specific status.
   */
  status?: string;
}
