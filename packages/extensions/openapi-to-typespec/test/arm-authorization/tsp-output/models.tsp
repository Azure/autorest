import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Authorization;

interface Operations extends Azure.ResourceManager.Operations {}

enum PrincipalType {
  User,
  Group,
  ServicePrincipal,
  ForeignGroup,
  Device,
}

enum RoleType {
  BuiltInRole,
  CustomRole,
}

enum AssignmentType {
  Activated,
  Assigned,
}

enum RoleManagementScheduleMemberType {
  Inherited,
  Direct,
  Group,
}

enum RoleManagementScheduleStatus {
  Accepted,
  PendingEvaluation,
  Granted,
  Denied,
  PendingProvisioning,
  Provisioned,
  PendingRevocation,
  Revoked,
  Canceled,
  Failed,
  PendingApprovalProvisioning,
  PendingApproval,
  FailedAsResourceIsLocked,
  PendingAdminDecision,
  AdminApproved,
  AdminDenied,
  TimedOut,
  ProvisioningStarted,
  Invalid,
  PendingScheduleCreation,
  ScheduleCreated,
  PendingExternalProvisioning,
}

enum ScopeType {
  subscription,
  managementgroup,
  resourcegroup,
}

enum RoleManagementScheduleRequestType {
  AdminAssign,
  AdminRemove,
  AdminUpdate,
  AdminExtend,
  AdminRenew,
  SelfActivate,
  SelfDeactivate,
  SelfExtend,
  SelfRenew,
}

enum RoleManagementScheduleExpirationType {
  AfterDuration,
  AfterDateTime,
  NoExpiration,
}

enum RoleManagementPolicyRuleType {
  RoleManagementPolicyApprovalRule,
  RoleManagementPolicyAuthenticationContextRule,
  RoleManagementPolicyEnablementRule,
  RoleManagementPolicyExpirationRule,
  RoleManagementPolicyNotificationRule,
}

enum RoleManagementAssignmentLevel {
  Assignment,
  Eligibility,
}

enum ApprovalMode {
  SingleStage,
  Serial,
  Parallel,
  NoApproval,
}

enum UserType {
  User,
  Group,
}

enum EnablementRules {
  MultiFactorAuthentication,
  Justification,
  Ticketing,
}

enum NotificationDeliveryMechanism {
  Email,
}

enum NotificationLevel {
  None,
  Critical,
  All,
}

enum RecipientType {
  Requestor,
  Approver,
  Admin,
}

@doc("ClassicAdministrator list result information.")
model ClassicAdministratorListResult is Azure.Core.Page<ClassicAdministrator>;

@doc("Classic Administrators")
model ClassicAdministrator {
  @doc("The ID of the administrator.")
  id?: string;

  @doc("The name of the administrator.")
  name?: string;

  @doc("The type of the administrator.")
  type?: string;

  @doc("Properties for the classic administrator.")
  properties?: ClassicAdministratorProperties;
}

@doc("Classic Administrator properties.")
model ClassicAdministratorProperties {
  @doc("The email address of the administrator.")
  emailAddress?: string;

  @doc("The role of the administrator.")
  role?: string;
}

@doc("Deny assignment properties.")
model DenyAssignmentProperties {
  @doc("The display name of the deny assignment.")
  denyAssignmentName?: string;

  @doc("The description of the deny assignment.")
  description?: string;

  @doc("An array of permissions that are denied by the deny assignment.")
  permissions?: DenyAssignmentPermission[];

  @doc("The deny assignment scope.")
  scope?: string;

  @doc("Determines if the deny assignment applies to child scopes. Default value is false.")
  doNotApplyToChildScopes?: boolean;

  @doc("Array of principals to which the deny assignment applies.")
  principals?: Principal[];

  @doc("Array of principals to which the deny assignment does not apply.")
  excludePrincipals?: Principal[];

  @doc("Specifies whether this deny assignment was created by Azure and cannot be edited or deleted.")
  isSystemProtected?: boolean;
}

@doc("Deny assignment permissions.")
model DenyAssignmentPermission {
  @doc("Actions to which the deny assignment does not grant access.")
  actions?: string[];

  @doc("Actions to exclude from that the deny assignment does not grant access.")
  notActions?: string[];

  @doc("Data actions to which the deny assignment does not grant access.")
  dataActions?: string[];

  @doc("Data actions to exclude from that the deny assignment does not grant access.")
  notDataActions?: string[];

  @doc("The conditions on the Deny assignment permission. This limits the resources it applies to.")
  condition?: string;

  @doc("Version of the condition.")
  conditionVersion?: string;
}

@doc("The name of the entity last modified it")
model Principal {
  @doc("The id of the principal made changes")
  id?: string;

  @doc("The name of the principal made changes")
  displayName?: string;

  @doc("Type of the principal.")
  @projectedName("json", "type")
  principalType?: PrincipalType;

  @doc("Email of principal")
  email?: string;
}

@doc("Resource Type")
model AuthorizationProviderResourceType {
  @doc("The resource type name.")
  name?: string;

  @doc("The resource type display name.")
  displayName?: string;

  @doc("The resource type operations.")
  operations?: ProviderOperation[];
}

@doc("Operation")
model ProviderOperation {
  @doc("The operation name.")
  name?: string;

  @doc("The operation display name.")
  displayName?: string;

  @doc("The operation description.")
  description?: string;

  @doc("The operation origin.")
  origin?: string;

  @doc("The operation properties.")
  properties?: Record<unknown>;

  @doc("The dataAction flag to specify the operation type.")
  isDataAction?: boolean;
}

@doc("Role assignment properties.")
model RoleAssignmentProperties {
  @doc("The role assignment scope.")
  @visibility("read")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId: string;

  @doc("The principal ID.")
  principalId: string;

  @doc("The principal type of the assigned principal ID.")
  principalType?: PrincipalType;

  @doc("Description of role assignment")
  description?: string;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently the only accepted value is '2.0'")
  conditionVersion?: string;

  @doc("Time it was created")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("Time it was updated")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedOn?: utcDateTime;

  @doc("Id of the user who created the assignment")
  @visibility("read")
  createdBy?: string;

  @doc("Id of the user who updated the assignment")
  @visibility("read")
  updatedBy?: string;

  @doc("Id of the delegated managed identity resource")
  delegatedManagedIdentityResourceId?: string;
}

@doc("Role assignment create parameters.")
model RoleAssignmentCreateParameters {
  @doc("Role assignment properties.")
  properties: RoleAssignmentProperties;
}

@doc("Permissions information.")
model PermissionGetResult is Azure.Core.Page<Permission>;

@doc("Role definition permissions.")
model Permission {
  @doc("Allowed actions.")
  actions?: string[];

  @doc("Denied actions.")
  notActions?: string[];

  @doc("Allowed Data actions.")
  dataActions?: string[];

  @doc("Denied Data actions.")
  notDataActions?: string[];
}

@doc("Role definition properties.")
model RoleDefinitionProperties {
  @doc("The role name.")
  roleName?: string;

  @doc("The role definition description.")
  description?: string;

  @doc("The role type.")
  @projectedName("json", "type")
  roleType?: RoleType;

  @doc("Role definition permissions.")
  permissions?: Permission[];

  @doc("Role definition assignable scopes.")
  assignableScopes?: string[];
}

@doc("Eligible child resources list operation result.")
model EligibleChildResourcesListResult
  is Azure.Core.Page<EligibleChildResource>;

@doc("Eligible child resource")
model EligibleChildResource {
  @doc("The resource scope Id.")
  @visibility("read")
  id?: string;

  @doc("The resource name.")
  @visibility("read")
  name?: string;

  @doc("The resource type.")
  @visibility("read")
  type?: string;
}

@doc("An error response from the service.")
@error
model CloudError {
  @doc("An error response from the service.")
  error?: CloudErrorBody;
}

@doc("An error response from the service.")
model CloudErrorBody {
  @doc("An identifier for the error. Codes are invariant and are intended to be consumed programmatically.")
  code?: string;

  @doc("A message describing the error, intended to be suitable for display in a user interface.")
  message?: string;
}

@doc("Role assignment schedule properties with scope.")
model RoleAssignmentScheduleProperties {
  @doc("The role assignment schedule scope.")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId?: string;

  @doc("The principal ID.")
  principalId?: string;

  @doc("The principal type of the assigned principal ID.")
  principalType?: PrincipalType;

  @doc("The id of roleAssignmentScheduleRequest used to create this roleAssignmentSchedule")
  roleAssignmentScheduleRequestId?: string;

  @doc("The id of roleEligibilitySchedule used to activated this roleAssignmentSchedule")
  linkedRoleEligibilityScheduleId?: string;

  @doc("Assignment type of the role assignment schedule")
  assignmentType?: AssignmentType;

  @doc("Membership type of the role assignment schedule")
  memberType?: RoleManagementScheduleMemberType;

  @doc("The status of the role assignment schedule.")
  status?: RoleManagementScheduleStatus;

  @doc("Start DateTime when role assignment schedule")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("End DateTime when role assignment schedule")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently accepted value is '2.0'")
  conditionVersion?: string;

  @doc("DateTime when role assignment schedule was created")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("DateTime when role assignment schedule was modified")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedOn?: utcDateTime;

  @doc("Additional properties of principal, scope and role definition")
  expandedProperties?: ExpandedProperties;
}

model ExpandedProperties {
  @doc("Details of the resource scope")
  scope?: ExpandedPropertiesScope;

  @doc("Details of role definition")
  roleDefinition?: ExpandedPropertiesRoleDefinition;

  @doc("Details of the principal")
  principal?: ExpandedPropertiesPrincipal;
}

@doc("Details of the resource scope")
model ExpandedPropertiesScope {
  @doc("Scope id of the resource")
  @projectedName("json", "id")
  scopeId?: string;

  @doc("Display name of the resource")
  @projectedName("json", "displayName")
  scopeDisplayName?: string;

  @doc("Type of the scope.")
  @projectedName("json", "type")
  scopeType?: ScopeType;
}

@doc("Details of role definition")
model ExpandedPropertiesRoleDefinition {
  @doc("Id of the role definition")
  @projectedName("json", "id")
  roleDefinitionId?: string;

  @doc("Display name of the role definition")
  @projectedName("json", "displayName")
  roleDefinitionDisplayName?: string;

  @doc("The role type.")
  @projectedName("json", "type")
  roleType?: RoleType;
}

@doc("Details of the principal")
model ExpandedPropertiesPrincipal {
  @doc("Id of the principal")
  @projectedName("json", "id")
  principalId?: string;

  @doc("Display name of the principal")
  @projectedName("json", "displayName")
  principalDisplayName?: string;

  @doc("Email id of the principal")
  email?: string;

  @doc("Type of the principal.")
  @projectedName("json", "type")
  principalType?: PrincipalType;
}

@doc("Role assignment schedule properties with scope.")
model RoleAssignmentScheduleInstanceProperties {
  @doc("The role assignment schedule scope.")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId?: string;

  @doc("The principal ID.")
  principalId?: string;

  @doc("The principal type of the assigned principal ID.")
  principalType?: PrincipalType;

  @doc("Id of the master role assignment schedule")
  roleAssignmentScheduleId?: string;

  @doc("Role Assignment Id in external system")
  originRoleAssignmentId?: string;

  @doc("The status of the role assignment schedule instance.")
  status?: RoleManagementScheduleStatus;

  @doc("The startDateTime of the role assignment schedule instance")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("The endDateTime of the role assignment schedule instance")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("roleEligibilityScheduleId used to activate")
  linkedRoleEligibilityScheduleId?: string;

  @doc("roleEligibilityScheduleInstanceId linked to this roleAssignmentScheduleInstance")
  linkedRoleEligibilityScheduleInstanceId?: string;

  @doc("Assignment type of the role assignment schedule")
  assignmentType?: AssignmentType;

  @doc("Membership type of the role assignment schedule")
  memberType?: RoleManagementScheduleMemberType;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently accepted value is '2.0'")
  conditionVersion?: string;

  @doc("DateTime when role assignment schedule was created")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("Additional properties of principal, scope and role definition")
  expandedProperties?: ExpandedProperties;
}

@doc("Role assignment schedule request properties with scope.")
model RoleAssignmentScheduleRequestProperties {
  @doc("The role assignment schedule request scope.")
  @visibility("read")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId: string;

  @doc("The principal ID.")
  principalId: string;

  @doc("The principal type of the assigned principal ID.")
  @visibility("read")
  principalType?: PrincipalType;

  @doc("The type of the role assignment schedule request. Eg: SelfActivate, AdminAssign etc")
  requestType: RoleManagementScheduleRequestType;

  @doc("The status of the role assignment schedule request.")
  @visibility("read")
  status?: RoleManagementScheduleStatus;

  @doc("The approvalId of the role assignment schedule request.")
  @visibility("read")
  approvalId?: string;

  @doc("The resultant role assignment schedule id or the role assignment schedule id being updated")
  targetRoleAssignmentScheduleId?: string;

  @doc("The role assignment schedule instance id being updated")
  targetRoleAssignmentScheduleInstanceId?: string;

  @doc("Schedule info of the role assignment schedule")
  scheduleInfo?: RoleAssignmentScheduleRequestPropertiesScheduleInfo;

  @doc("The linked role eligibility schedule id - to activate an eligibility.")
  linkedRoleEligibilityScheduleId?: string;

  @doc("Justification for the role assignment")
  justification?: string;

  @doc("Ticket Info of the role assignment")
  ticketInfo?: RoleAssignmentScheduleRequestPropertiesTicketInfo;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently accepted value is '2.0'")
  conditionVersion?: string;

  @doc("DateTime when role assignment schedule request was created")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("Id of the user who created this request")
  @visibility("read")
  requestorId?: string;

  @doc("Additional properties of principal, scope and role definition")
  @visibility("read")
  expandedProperties?: ExpandedProperties;
}

@doc("Schedule info of the role assignment schedule")
model RoleAssignmentScheduleRequestPropertiesScheduleInfo {
  @doc("Start DateTime of the role assignment schedule.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("Expiration of the role assignment schedule")
  expiration?: RoleAssignmentScheduleRequestPropertiesScheduleInfoExpiration;
}

@doc("Expiration of the role assignment schedule")
model RoleAssignmentScheduleRequestPropertiesScheduleInfoExpiration {
  @doc("Type of the role assignment schedule expiration")
  @projectedName("json", "type")
  expirationType?: RoleManagementScheduleExpirationType;

  @doc("End DateTime of the role assignment schedule.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("Duration of the role assignment schedule in TimeSpan.")
  duration?: duration;
}

@doc("Ticket Info of the role assignment")
model RoleAssignmentScheduleRequestPropertiesTicketInfo {
  @doc("Ticket number for the role assignment")
  ticketNumber?: string;

  @doc("Ticket system name for the role assignment")
  ticketSystem?: string;
}

@doc("Role eligibility schedule properties with scope.")
model RoleEligibilityScheduleProperties {
  @doc("The role eligibility schedule scope.")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId?: string;

  @doc("The principal ID.")
  principalId?: string;

  @doc("The principal type of the assigned principal ID.")
  principalType?: PrincipalType;

  @doc("The id of roleEligibilityScheduleRequest used to create this roleAssignmentSchedule")
  roleEligibilityScheduleRequestId?: string;

  @doc("Membership type of the role eligibility schedule")
  memberType?: RoleManagementScheduleMemberType;

  @doc("The status of the role eligibility schedule.")
  status?: RoleManagementScheduleStatus;

  @doc("Start DateTime when role eligibility schedule")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("End DateTime when role eligibility schedule")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently accepted value is '2.0'")
  conditionVersion?: string;

  @doc("DateTime when role eligibility schedule was created")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("DateTime when role eligibility schedule was modified")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  updatedOn?: utcDateTime;

  @doc("Additional properties of principal, scope and role definition")
  expandedProperties?: ExpandedProperties;
}

@doc("Role eligibility schedule properties with scope.")
model RoleEligibilityScheduleInstanceProperties {
  @doc("The role eligibility schedule scope.")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId?: string;

  @doc("The principal ID.")
  principalId?: string;

  @doc("The principal type of the assigned principal ID.")
  principalType?: PrincipalType;

  @doc("Id of the master role eligibility schedule")
  roleEligibilityScheduleId?: string;

  @doc("The status of the role eligibility schedule instance")
  status?: RoleManagementScheduleStatus;

  @doc("The startDateTime of the role eligibility schedule instance")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("The endDateTime of the role eligibility schedule instance")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("Membership type of the role eligibility schedule")
  memberType?: RoleManagementScheduleMemberType;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently accepted value is '2.0'")
  conditionVersion?: string;

  @doc("DateTime when role eligibility schedule was created")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("Additional properties of principal, scope and role definition")
  expandedProperties?: ExpandedProperties;
}

@doc("Role eligibility schedule request properties with scope.")
model RoleEligibilityScheduleRequestProperties {
  @doc("The role eligibility schedule request scope.")
  @visibility("read")
  scope?: string;

  @doc("The role definition ID.")
  roleDefinitionId: string;

  @doc("The principal ID.")
  principalId: string;

  @doc("The principal type of the assigned principal ID.")
  @visibility("read")
  principalType?: PrincipalType;

  @doc("The type of the role assignment schedule request. Eg: SelfActivate, AdminAssign etc")
  requestType: RoleManagementScheduleRequestType;

  @doc("The status of the role eligibility schedule request.")
  @visibility("read")
  status?: RoleManagementScheduleStatus;

  @doc("The approvalId of the role eligibility schedule request.")
  @visibility("read")
  approvalId?: string;

  @doc("Schedule info of the role eligibility schedule")
  scheduleInfo?: RoleEligibilityScheduleRequestPropertiesScheduleInfo;

  @doc("The resultant role eligibility schedule id or the role eligibility schedule id being updated")
  targetRoleEligibilityScheduleId?: string;

  @doc("The role eligibility schedule instance id being updated")
  targetRoleEligibilityScheduleInstanceId?: string;

  @doc("Justification for the role eligibility")
  justification?: string;

  @doc("Ticket Info of the role eligibility")
  ticketInfo?: RoleEligibilityScheduleRequestPropertiesTicketInfo;

  @doc("The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'")
  condition?: string;

  @doc("Version of the condition. Currently accepted value is '2.0'")
  conditionVersion?: string;

  @doc("DateTime when role eligibility schedule request was created")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("Id of the user who created this request")
  @visibility("read")
  requestorId?: string;

  @doc("Additional properties of principal, scope and role definition")
  @visibility("read")
  expandedProperties?: ExpandedProperties;
}

@doc("Schedule info of the role eligibility schedule")
model RoleEligibilityScheduleRequestPropertiesScheduleInfo {
  @doc("Start DateTime of the role eligibility schedule.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("Expiration of the role eligibility schedule")
  expiration?: RoleEligibilityScheduleRequestPropertiesScheduleInfoExpiration;
}

@doc("Expiration of the role eligibility schedule")
model RoleEligibilityScheduleRequestPropertiesScheduleInfoExpiration {
  @doc("Type of the role eligibility schedule expiration")
  @projectedName("json", "type")
  expirationType?: RoleManagementScheduleExpirationType;

  @doc("End DateTime of the role eligibility schedule.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("Duration of the role eligibility schedule in TimeSpan.")
  duration?: duration;
}

@doc("Ticket Info of the role eligibility")
model RoleEligibilityScheduleRequestPropertiesTicketInfo {
  @doc("Ticket number for the role eligibility")
  ticketNumber?: string;

  @doc("Ticket system name for the role eligibility")
  ticketSystem?: string;
}

@doc("Role management policy properties with scope.")
model RoleManagementPolicyProperties {
  @doc("The role management policy scope.")
  scope?: string;

  @doc("The role management policy display name.")
  displayName?: string;

  @doc("The role management policy description.")
  description?: string;

  @doc("The role management policy is default policy.")
  isOrganizationDefault?: boolean;

  @doc("The name of the entity last modified it")
  @visibility("read")
  lastModifiedBy?: Principal;

  @doc("The last modified date time.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The rule applied to the policy.")
  rules?: RoleManagementPolicyRule[];

  @doc("The readonly computed rule applied to the policy.")
  @visibility("read")
  effectiveRules?: RoleManagementPolicyRule[];

  @doc("Additional properties of scope")
  @visibility("read")
  policyProperties?: PolicyProperties;
}

@doc("The role management policy rule.")
@discriminator("ruleType")
model RoleManagementPolicyRule {
  @doc("The id of the rule.")
  id?: string;

  @doc("The target of the current rule.")
  target?: RoleManagementPolicyRuleTarget;
}

@doc("The role management policy rule target.")
model RoleManagementPolicyRuleTarget {
  @doc("The caller of the setting.")
  caller?: string;

  @doc("The type of operation.")
  operations?: string[];

  @doc("The assignment level to which rule is applied.")
  level?: RoleManagementAssignmentLevel;

  @doc("The list of target objects.")
  targetObjects?: string[];

  @doc("The list of inheritable settings.")
  inheritableSettings?: string[];

  @doc("The list of enforced settings.")
  enforcedSettings?: string[];
}

@doc("Expanded info of resource scope")
model PolicyProperties {
  @doc("Details of the resource scope")
  @visibility("read")
  scope?: PolicyPropertiesScope;
}

@doc("Details of the resource scope")
model PolicyPropertiesScope {
  @doc("Scope id of the resource")
  @projectedName("json", "id")
  scopeId?: string;

  @doc("Display name of the resource")
  @projectedName("json", "displayName")
  scopeDisplayName?: string;

  @doc("Type of the scope.")
  @projectedName("json", "type")
  scopeType?: ScopeType;
}

@doc("Role management policy assignment properties with scope.")
model RoleManagementPolicyAssignmentProperties {
  @doc("The role management policy scope.")
  scope?: string;

  @doc("The role definition of management policy assignment.")
  roleDefinitionId?: string;

  @doc("The policy id role management policy assignment.")
  policyId?: string;

  @doc("The readonly computed rule applied to the policy.")
  @visibility("read")
  effectiveRules?: RoleManagementPolicyRule[];

  @doc("Additional properties of scope, role definition and policy")
  @visibility("read")
  policyAssignmentProperties?: PolicyAssignmentProperties;
}

@doc("Expanded info of resource scope, role definition and policy")
model PolicyAssignmentProperties {
  @doc("Details of the resource scope")
  scope?: PolicyAssignmentPropertiesScope;

  @doc("Details of role definition")
  roleDefinition?: PolicyAssignmentPropertiesRoleDefinition;

  @doc("Details of the policy")
  policy?: PolicyAssignmentPropertiesPolicy;
}

@doc("Details of the resource scope")
model PolicyAssignmentPropertiesScope {
  @doc("Scope id of the resource")
  @projectedName("json", "id")
  scopeId?: string;

  @doc("Display name of the resource")
  @projectedName("json", "displayName")
  scopeDisplayName?: string;

  @doc("Type of the scope.")
  @projectedName("json", "type")
  scopeType?: ScopeType;
}

@doc("Details of role definition")
model PolicyAssignmentPropertiesRoleDefinition {
  @doc("Id of the role definition")
  @projectedName("json", "id")
  roleDefinitionId?: string;

  @doc("Display name of the role definition")
  @projectedName("json", "displayName")
  roleDefinitionDisplayName?: string;

  @doc("The role type.")
  @projectedName("json", "type")
  roleType?: RoleType;
}

@doc("Details of the policy")
model PolicyAssignmentPropertiesPolicy {
  @doc("Id of the policy")
  @projectedName("json", "id")
  policyId?: string;

  @doc("The name of the entity last modified it")
  @visibility("read")
  lastModifiedBy?: Principal;

  @doc("The last modified date time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;
}

@doc("Deny Assignments filter")
model DenyAssignmentFilter {
  @doc("Return deny assignment with specified name.")
  denyAssignmentName?: string;

  @doc("Return all deny assignments where the specified principal is listed in the principals list of deny assignments.")
  principalId?: string;

  @doc("Return all deny assignments where the specified principal is listed either in the principals list or exclude principals list of deny assignments.")
  gdprExportPrincipalId?: string;
}

@doc("Failed validation result details")
model ValidationResponseErrorInfo {
  @doc("Error code indicating why validation failed")
  @visibility("read")
  code?: string;

  @doc("Message indicating why validation failed")
  @visibility("read")
  message?: string;
}

@doc("Validation response")
model ValidationResponse {
  @doc("Whether or not validation succeeded")
  @visibility("read")
  isValid?: boolean;

  @doc("Failed validation result details")
  errorInfo?: ValidationResponseErrorInfo;
}

@doc("Role Assignments filter")
model RoleAssignmentFilter {
  @doc("Returns role assignment of the specific principal.")
  principalId?: string;
}

@doc("Role Definitions filter")
model RoleDefinitionFilter {
  @doc("Returns role definition with the specific name.")
  roleName?: string;

  @doc("Returns role definition with the specific type.")
  type?: string;
}

@doc("The role management policy approval rule.")
model RoleManagementPolicyApprovalRule extends RoleManagementPolicyRule {
  @doc("The approval setting")
  setting?: ApprovalSettings;

  @doc("The type of rule")
  ruleType: "RoleManagementPolicyApprovalRule";
}

@doc("The approval settings.")
model ApprovalSettings {
  @doc("Determines whether approval is required or not.")
  isApprovalRequired?: boolean;

  @doc("Determines whether approval is required for assignment extension.")
  isApprovalRequiredForExtension?: boolean;

  @doc("Determine whether requestor justification is required.")
  isRequestorJustificationRequired?: boolean;

  @doc("The type of rule")
  approvalMode?: ApprovalMode;

  @doc("The approval stages of the request.")
  approvalStages?: ApprovalStage[];
}

@doc("The approval stage.")
model ApprovalStage {
  @doc("The time in days when approval request would be timed out")
  approvalStageTimeOutInDays?: int32;

  @doc("Determines whether approver need to provide justification for his decision.")
  isApproverJustificationRequired?: boolean;

  @doc("The time in minutes when the approval request would be escalated if the primary approver does not approve")
  escalationTimeInMinutes?: int32;

  @doc("The primary approver of the request.")
  primaryApprovers?: UserSet[];

  @doc("The value determine whether escalation feature is enabled.")
  isEscalationEnabled?: boolean;

  @doc("The escalation approver of the request.")
  escalationApprovers?: UserSet[];
}

@doc("The detail of a user.")
model UserSet {
  @doc("The type of user.")
  userType?: UserType;

  @doc("The value indicating whether the user is a backup fallback approver")
  isBackup?: boolean;

  @doc("The object id of the user.")
  id?: string;

  @doc("The description of the user.")
  description?: string;
}

@doc("The role management policy authentication context rule.")
model RoleManagementPolicyAuthenticationContextRule
  extends RoleManagementPolicyRule {
  @doc("The value indicating if rule is enabled.")
  isEnabled?: boolean;

  @doc("The claim value.")
  claimValue?: string;

  @doc("The type of rule")
  ruleType: "RoleManagementPolicyAuthenticationContextRule";
}

@doc("The role management policy enablement rule.")
model RoleManagementPolicyEnablementRule extends RoleManagementPolicyRule {
  @doc("The list of enabled rules.")
  enabledRules?: EnablementRules[];

  @doc("The type of rule")
  ruleType: "RoleManagementPolicyEnablementRule";
}

@doc("The role management policy expiration rule.")
model RoleManagementPolicyExpirationRule extends RoleManagementPolicyRule {
  @doc("The value indicating whether expiration is required.")
  isExpirationRequired?: boolean;

  @doc("The maximum duration of expiration in timespan.")
  maximumDuration?: duration;

  @doc("The type of rule")
  ruleType: "RoleManagementPolicyExpirationRule";
}

@doc("The role management policy notification rule.")
model RoleManagementPolicyNotificationRule extends RoleManagementPolicyRule {
  @doc("The type of notification.")
  notificationType?: NotificationDeliveryMechanism;

  @doc("The notification level.")
  notificationLevel?: NotificationLevel;

  @doc("The recipient type.")
  recipientType?: RecipientType;

  @doc("The list of notification recipients.")
  notificationRecipients?: string[];

  @doc("Determines if the notification will be sent to the recipient type specified in the policy rule.")
  isDefaultRecipientsEnabled?: boolean;

  @doc("The type of rule")
  ruleType: "RoleManagementPolicyNotificationRule";
}

@doc("Role assignment schedule filter")
model RoleAssignmentScheduleFilter {
  @doc("Returns role assignment schedule of the specific principal.")
  principalId?: string;

  @doc("Returns role assignment schedule of the specific role definition.")
  roleDefinitionId?: string;

  @doc("Returns role assignment schedule instances of the specific status.")
  status?: string;
}

@doc("Role assignment schedule instance filter")
model RoleAssignmentScheduleInstanceFilter {
  @doc("Returns role assignment schedule instances of the specific principal.")
  principalId?: string;

  @doc("Returns role assignment schedule instances of the specific role definition.")
  roleDefinitionId?: string;

  @doc("Returns role assignment schedule instances of the specific status.")
  status?: string;

  @doc("Returns role assignment schedule instances belonging to a specific role assignment schedule.")
  roleAssignmentScheduleId?: string;
}

@doc("Role assignment schedule request filter")
model RoleAssignmentScheduleRequestFilter {
  @doc("Returns role assignment requests of the specific principal.")
  principalId?: string;

  @doc("Returns role assignment requests of the specific role definition.")
  roleDefinitionId?: string;

  @doc("Returns role assignment requests created by specific principal.")
  requestorId?: string;

  @doc("Returns role assignment requests of specific status.")
  status?: string;
}

@doc("Role eligibility schedule filter")
model RoleEligibilityScheduleFilter {
  @doc("Returns role eligibility schedule of the specific principal.")
  principalId?: string;

  @doc("Returns role eligibility schedule of the specific role definition.")
  roleDefinitionId?: string;

  @doc("Returns role eligibility schedule of the specific status.")
  status?: string;
}

@doc("Role eligibility schedule instance filter")
model RoleEligibilityScheduleInstanceFilter {
  @doc("Returns role eligibility schedule instances of the specific principal.")
  principalId?: string;

  @doc("Returns role eligibility schedule instances of the specific role definition.")
  roleDefinitionId?: string;

  @doc("Returns role eligibility schedule instances of the specific status.")
  status?: string;

  @doc("Returns role eligibility schedule instances belonging to a specific role eligibility schedule.")
  roleEligibilityScheduleId?: string;
}

@doc("Role eligibility schedule request filter")
model RoleEligibilityScheduleRequestFilter {
  @doc("Returns role eligibility requests of the specific principal.")
  principalId?: string;

  @doc("Returns role eligibility requests of the specific role definition.")
  roleDefinitionId?: string;

  @doc("Returns role eligibility requests created by specific principal.")
  requestorId?: string;

  @doc("Returns role eligibility requests of specific status.")
  status?: string;
}
