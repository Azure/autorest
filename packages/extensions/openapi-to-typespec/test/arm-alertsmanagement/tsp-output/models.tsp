import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.AlertsManagement;

interface Operations extends Azure.ResourceManager.Operations {}

enum Field {
  Severity,
  MonitorService,
  MonitorCondition,
  SignalType,
  TargetResourceType,
  TargetResource,
  TargetResourceGroup,
  AlertRuleId,
  AlertRuleName,
  Description,
  AlertContext,
}

enum Operator {
  Equals,
  NotEquals,
  Contains,
  DoesNotContain,
}

enum RecurrenceType {
  Daily,
  Weekly,
  Monthly,
}

enum ActionType {
  AddActionGroups,
  RemoveAllActionGroups,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum Identifier {
  MonitorServiceList,
}

enum MetadataIdentifier {
  MonitorServiceList,
}

enum MonitorService {
  `Application Insights`,
  `ActivityLog Administrative`,
  `ActivityLog Security`,
  `ActivityLog Recommendation`,
  `ActivityLog Policy`,
  `ActivityLog Autoscale`,
  `Log Analytics`,
  Nagios,
  Platform,
  SCOM,
  ServiceHealth,
  SmartDetector,
  `VM Insights`,
  Zabbix,
}

enum MonitorCondition {
  Fired,
  Resolved,
}

enum Severity {
  Sev0,
  Sev1,
  Sev2,
  Sev3,
  Sev4,
}

enum AlertState {
  New,
  Acknowledged,
  Closed,
}

enum AlertsSortByFields {
  name,
  severity,
  alertState,
  monitorCondition,
  targetResource,
  targetResourceName,
  targetResourceGroup,
  targetResourceType,
  startDateTime,
  lastModifiedDateTime,
}

enum SortOrder {
  asc,
  desc,
}

enum TimeRange {
  `1h`,
  `1d`,
  `7d`,
  `30d`,
}

enum SignalType {
  Metric,
  Log,
  Unknown,
}

enum AlertsSummaryGroupByFields {
  severity,
  alertState,
  monitorCondition,
  monitorService,
  signalType,
  alertRule,
}

enum SmartGroupsSortByFields {
  alertsCount,
  state,
  severity,
  startDateTime,
  lastModifiedDateTime,
}

enum SmartGroupState {
  New,
  Acknowledged,
  Closed,
}

enum DaysOfWeek {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}
@Azure.Core.fixed
enum AlertModificationEvent {
  AlertCreated,
  StateChange,
  MonitorConditionChange,
  SeverityChange,
  ActionRuleTriggered,
  ActionRuleSuppressed,
  ActionsTriggered,
  ActionsSuppressed,
  ActionsFailed,
}
@Azure.Core.fixed
enum SmartGroupModificationEvent {
  SmartGroupCreated,
  StateChange,
  AlertAdded,
  AlertRemoved,
}

@doc("Alert processing rule properties defining scopes, conditions and scheduling logic for alert processing rule.")
model AlertProcessingRuleProperties {
  @doc("Scopes on which alert processing rule will apply.")
  scopes: string[];

  @doc("Conditions on which alerts will be filtered.")
  conditions?: Condition[];

  @doc("Scheduling for alert processing rule.")
  schedule?: Schedule;

  @doc("Actions to be applied.")
  actions: Action[];

  @doc("Description of alert processing rule.")
  description?: string;

  @doc("Indicates if the given alert processing rule is enabled or disabled.")
  enabled?: boolean;
}

@doc("Condition to trigger an alert processing rule.")
model Condition {
  @doc("Field for a given condition.")
  field?: Field;

  @doc("Operator for a given condition.")
  operator?: Operator;

  @doc("List of values to match for a given condition.")
  values?: string[];
}

@doc("Scheduling configuration for a given alert processing rule.")
model Schedule {
  @doc("Scheduling effective from time. Date-Time in ISO-8601 format without timezone suffix.")
  @pattern("^(?:(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?))$")
  effectiveFrom?: string;

  @doc("Scheduling effective until time. Date-Time in ISO-8601 format without timezone suffix.")
  @pattern("^(?:(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?))$")
  effectiveUntil?: string;

  @doc("Scheduling time zone.")
  timeZone?: string;

  @doc("List of recurrences.")
  recurrences?: Recurrence[];
}

@doc("Recurrence object.")
@discriminator("recurrenceType")
model Recurrence {
  @doc("Start time for recurrence.")
  startTime?: plainTime;

  @doc("End time for recurrence.")
  endTime?: plainTime;
}

@doc("Action to be applied.")
@discriminator("actionType")
model Action {}

@doc("An azure managed resource object.")
model ManagedResource extends Resource {
  @doc("Resource location")
  @visibility("read", "create")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  location: string;

  @doc("Resource tags")
  tags?: Record<string>;
}

@doc("An azure resource object")
model Resource {
  @doc("Azure resource Id")
  @visibility("read")
  id?: string;

  @doc("Azure resource type")
  @visibility("read")
  type?: string;

  @doc("Azure resource name")
  @visibility("read")
  name?: string;
}

@doc("An error response from the service.")
@error
model AlertProcessingRuleErrorResponse {
  @doc("Details of error response.")
  error?: AlertProcessingRuleErrorResponseBody;
}

@doc("Details of error response.")
model AlertProcessingRuleErrorResponseBody {
  @doc("Error code, intended to be consumed programmatically.")
  code?: string;

  @doc("Description of the error, intended for display in user interface.")
  message?: string;

  @doc("Target of the particular error, for example name of the property.")
  target?: string;

  @doc("A list of additional details about the error.")
  details?: AlertProcessingRuleErrorResponseBody[];
}

@doc("An error response from the service.")
@error
model AlertsManagementErrorResponse {
  @doc("Details of error response.")
  error?: AlertsManagementErrorResponseBody;
}

@doc("Details of error response.")
model AlertsManagementErrorResponseBody {
  @doc("Error code, intended to be consumed programmatically.")
  code?: string;

  @doc("Description of the error, intended for display in user interface.")
  message?: string;

  @doc("Target of the particular error, for example name of the property.")
  target?: string;

  @doc("A list of additional details about the error.")
  details?: AlertsManagementErrorResponseBody[];
}

@doc("alert meta data information.")
model AlertsMetaData {
  @doc("alert meta data property bag")
  properties?: AlertsMetaDataProperties;
}

@doc("alert meta data property bag")
@discriminator("metadataIdentifier")
model AlertsMetaDataProperties {}

@doc("Alert property bag")
model AlertProperties {
  @doc("This object contains consistent fields across different monitor services.")
  essentials?: Essentials;

  @doc("Information specific to the monitor service that gives more contextual details about the alert.")
  @visibility("read")
  context?: Record<unknown>;

  @doc("Config which would be used for displaying the data in portal.")
  @visibility("read")
  egressConfig?: Record<unknown>;
}

@doc("This object contains consistent fields across different monitor services.")
model Essentials {
  @doc("Severity of alert Sev0 being highest and Sev4 being lowest.")
  @visibility("read")
  severity?: Severity;

  @doc("The type of signal the alert is based on, which could be metrics, logs or activity logs.")
  @visibility("read")
  signalType?: SignalType;

  @doc("Alert object state, which can be modified by the user.")
  @visibility("read")
  alertState?: AlertState;

  @doc("Condition of the rule at the monitor service. It represents whether the underlying conditions have crossed the defined alert rule thresholds.")
  @visibility("read")
  monitorCondition?: MonitorCondition;

  @doc("Target ARM resource, on which alert got created.")
  targetResource?: string;

  @doc("Name of the target ARM resource name, on which alert got created.")
  targetResourceName?: string;

  @doc("Resource group of target ARM resource, on which alert got created.")
  targetResourceGroup?: string;

  @doc("Resource type of target ARM resource, on which alert got created.")
  targetResourceType?: string;

  @doc("Monitor service on which the rule(monitor) is set.")
  @visibility("read")
  monitorService?: MonitorService;

  @doc("Rule(monitor) which fired alert instance. Depending on the monitor service,  this would be ARM id or name of the rule.")
  @visibility("read")
  alertRule?: string;

  @doc("Unique Id created by monitor service for each alert instance. This could be used to track the issue at the monitor service, in case of Nagios, Zabbix, SCOM etc.")
  @visibility("read")
  sourceCreatedId?: string;

  @doc("Unique Id of the smart group")
  @visibility("read")
  smartGroupId?: string;

  @doc("Verbose reason describing the reason why this alert instance is added to a smart group")
  @visibility("read")
  smartGroupingReason?: string;

  @doc("Creation time(ISO-8601 format) of alert instance.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("Last modification time(ISO-8601 format) of alert instance.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("Resolved time(ISO-8601 format) of alert instance. This will be updated when monitor service resolves the alert instance because the rule condition is no longer met.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  monitorConditionResolvedDateTime?: utcDateTime;

  @doc("User who last modified the alert, in case of monitor service updates user would be 'system', otherwise name of the user.")
  @visibility("read")
  lastModifiedUserName?: string;

  @doc("Action status")
  actionStatus?: ActionStatus;

  @doc("Alert description.")
  description?: string;
}

@doc("Action status")
model ActionStatus {
  @doc("Value indicating whether alert is suppressed.")
  isSuppressed?: boolean;
}

@doc("Alert Modification details")
model AlertModification extends Resource {
  @doc("Properties of the alert modification item.")
  properties?: AlertModificationProperties;
}

@doc("Properties of the alert modification item.")
model AlertModificationProperties {
  @doc("Unique Id of the alert for which the history is being retrieved")
  @visibility("read")
  alertId?: string;

  @doc("Modification details")
  modifications?: AlertModificationItem[];
}

@doc("Alert modification item.")
model AlertModificationItem {
  @doc("Reason for the modification")
  modificationEvent?: AlertModificationEvent;

  @doc("Old value")
  oldValue?: string;

  @doc("New value")
  newValue?: string;

  @doc("Modified date and time")
  modifiedAt?: string;

  @doc("Modified user details (Principal client name)")
  modifiedBy?: string;

  @doc("Modification comments")
  comments?: string;

  @doc("Description of the modification")
  description?: string;
}

@doc("Summary of alerts based on the input filters and 'groupby' parameters.")
model AlertsSummary extends Resource {
  @doc("Group the result set.")
  properties?: AlertsSummaryGroup;
}

@doc("Group the result set.")
model AlertsSummaryGroup {
  @doc("Total count of the result set.")
  total?: int32;

  @doc("Total count of the smart groups.")
  smartGroupsCount?: int32;

  @doc("Name of the field aggregated")
  groupedby?: string;

  @doc("List of the items")
  values?: AlertsSummaryGroupItem[];
}

@doc("Alerts summary group item")
model AlertsSummaryGroupItem {
  @doc("Value of the aggregated field")
  name?: string;

  @doc("Count of the aggregated field")
  count?: int32;

  @doc("Name of the field aggregated")
  groupedby?: string;

  @doc("List of the items")
  values?: AlertsSummaryGroupItem[];
}

@doc("Properties of smart group.")
model SmartGroupProperties {
  @doc("Total number of alerts in smart group")
  alertsCount?: int32;

  @doc("Smart group state")
  @visibility("read")
  smartGroupState?: SmartGroupState;

  @doc("Severity of smart group is the highest(Sev0 >... > Sev4) severity of all the alerts in the group.")
  @visibility("read")
  severity?: Severity;

  @doc("Creation time of smart group. Date-Time in ISO-8601 format.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("Last updated time of smart group. Date-Time in ISO-8601 format.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("Last modified by user name.")
  @visibility("read")
  lastModifiedUserName?: string;

  @doc("Summary of target resources in the smart group")
  resources?: SmartGroupAggregatedProperty[];

  @doc("Summary of target resource types in the smart group")
  resourceTypes?: SmartGroupAggregatedProperty[];

  @doc("Summary of target resource groups in the smart group")
  resourceGroups?: SmartGroupAggregatedProperty[];

  @doc("Summary of monitorServices in the smart group")
  monitorServices?: SmartGroupAggregatedProperty[];

  @doc("Summary of monitorConditions in the smart group")
  monitorConditions?: SmartGroupAggregatedProperty[];

  @doc("Summary of alertStates in the smart group")
  alertStates?: SmartGroupAggregatedProperty[];

  @doc("Summary of alertSeverities in the smart group")
  alertSeverities?: SmartGroupAggregatedProperty[];

  @doc("The URI to fetch the next page of alerts. Call ListNext() with this URI to fetch the next page alerts.")
  nextLink?: string;
}

@doc("Aggregated property of each type")
model SmartGroupAggregatedProperty {
  @doc("Name of the type.")
  name?: string;

  @doc("Total number of items of type.")
  count?: int32;
}

@doc("An error response from the service.")
@error
model SmartGroupErrorResponse {
  @doc("Details of error response.")
  error?: SmartGroupErrorResponseBody;
}

@doc("Details of error response.")
model SmartGroupErrorResponseBody {
  @doc("Error code, intended to be consumed programmatically.")
  code?: string;

  @doc("Description of the error, intended for display in user interface.")
  message?: string;

  @doc("Target of the particular error, for example name of the property.")
  target?: string;

  @doc("A list of additional details about the error.")
  details?: SmartGroupErrorResponseBody[];
}

@doc("Alert Modification details")
model SmartGroupModification extends Resource {
  @doc("Properties of the smartGroup modification item.")
  properties?: SmartGroupModificationProperties;
}

@doc("Properties of the smartGroup modification item.")
model SmartGroupModificationProperties {
  @doc("Unique Id of the smartGroup for which the history is being retrieved")
  @visibility("read")
  smartGroupId?: string;

  @doc("Modification details")
  modifications?: SmartGroupModificationItem[];

  @doc("URL to fetch the next set of results.")
  nextLink?: string;
}

@doc("smartGroup modification item.")
model SmartGroupModificationItem {
  @doc("Reason for the modification")
  modificationEvent?: SmartGroupModificationEvent;

  @doc("Old value")
  oldValue?: string;

  @doc("New value")
  newValue?: string;

  @doc("Modified date and time")
  modifiedAt?: string;

  @doc("Modified user details (Principal client name)")
  modifiedBy?: string;

  @doc("Modification comments")
  comments?: string;

  @doc("Description of the modification")
  description?: string;
}

@doc("Daily recurrence object.")
model DailyRecurrence extends Recurrence {
  @doc("Specifies when the recurrence should be applied.")
  recurrenceType: "Daily";
}

@doc("Weekly recurrence object.")
model WeeklyRecurrence extends Recurrence {
  @doc("Specifies the values for weekly recurrence pattern.")
  daysOfWeek: DaysOfWeek[];

  @doc("Specifies when the recurrence should be applied.")
  recurrenceType: "Weekly";
}

@doc("Monthly recurrence object.")
model MonthlyRecurrence extends Recurrence {
  @doc("Specifies the values for monthly recurrence pattern.")
  daysOfMonth: int32[];

  @doc("Specifies when the recurrence should be applied.")
  recurrenceType: "Monthly";
}

@doc("Add action groups to alert processing rule.")
model AddActionGroups extends Action {
  @doc("List of action group Ids to add to alert processing rule.")
  actionGroupIds: string[];

  @doc("Action that should be applied.")
  actionType: "AddActionGroups";
}

@doc("Indicates if all action groups should be removed.")
model RemoveAllActionGroups extends Action {
  @doc("Action that should be applied.")
  actionType: "RemoveAllActionGroups";
}

@doc("Monitor service details")
model MonitorServiceList extends AlertsMetaDataProperties {
  @doc("Array of operations")
  data: MonitorServiceDetails[];

  @doc("Identification of the information to be retrieved by API call")
  metadataIdentifier: "MonitorServiceList";
}

@doc("Details of a monitor service")
model MonitorServiceDetails {
  @doc("Monitor service name")
  name?: string;

  @doc("Monitor service display name")
  displayName?: string;
}
