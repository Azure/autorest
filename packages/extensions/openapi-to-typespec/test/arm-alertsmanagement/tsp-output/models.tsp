import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.AlertsManagement;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * Field for a given condition.
 */
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

/**
 * Operator for a given condition.
 */
enum Operator {
  Equals,
  NotEquals,
  Contains,
  DoesNotContain,
}

/**
 * Specifies when the recurrence should be applied.
 */
enum RecurrenceType {
  Daily,
  Weekly,
  Monthly,
}

enum Identifier {
  MonitorServiceList,
}

/**
 * Identification of the information to be retrieved by API call
 */
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

/**
 * The type of signal the alert is based on, which could be metrics, logs or activity logs.
 */
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

/**
 * Smart group state
 */
enum SmartGroupState {
  New,
  Acknowledged,
  Closed,
}

/**
 * Days of week.
 */
enum DaysOfWeek {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

/**
 * Reason for the modification
 */
@fixed
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

/**
 * Reason for the modification
 */
@fixed
enum SmartGroupModificationEvent {
  SmartGroupCreated,
  StateChange,
  AlertAdded,
  AlertRemoved,
}

/**
 * Alert processing rule properties defining scopes, conditions and scheduling logic for alert processing rule.
 */
model AlertProcessingRuleProperties {
  /**
   * Scopes on which alert processing rule will apply.
   */
  scopes: string[];

  /**
   * Conditions on which alerts will be filtered.
   */
  conditions?: Condition[];

  /**
   * Scheduling for alert processing rule.
   */
  schedule?: Schedule;

  /**
   * Actions to be applied.
   */
  actions: Action[];

  /**
   * Description of alert processing rule.
   */
  description?: string;

  /**
   * Indicates if the given alert processing rule is enabled or disabled.
   */
  enabled?: boolean = true;
}

/**
 * Condition to trigger an alert processing rule.
 */
model Condition {
  /**
   * Field for a given condition.
   */
  field?: Field;

  /**
   * Operator for a given condition.
   */
  operator?: Operator;

  /**
   * List of values to match for a given condition.
   */
  values?: string[];
}

/**
 * Scheduling configuration for a given alert processing rule.
 */
model Schedule {
  /**
   * Scheduling effective from time. Date-Time in ISO-8601 format without timezone suffix.
   */
  @pattern("^(?:(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?))$")
  effectiveFrom?: string;

  /**
   * Scheduling effective until time. Date-Time in ISO-8601 format without timezone suffix.
   */
  @pattern("^(?:(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?))$")
  effectiveUntil?: string;

  /**
   * Scheduling time zone.
   */
  timeZone?: string;

  /**
   * List of recurrences.
   */
  recurrences?: Recurrence[];
}

/**
 * Recurrence object.
 */
@discriminator("recurrenceType")
model Recurrence {
  /**
   * Start time for recurrence.
   */
  startTime?: plainTime;

  /**
   * End time for recurrence.
   */
  endTime?: plainTime;
}

/**
 * Action to be applied.
 */
@discriminator("actionType")
model Action {}

/**
 * An azure managed resource object.
 */
model ManagedResource extends Resource {
  /**
   * Resource location
   */
  @visibility("read", "create")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  location: string;

  /**
   * Resource tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * An azure resource object
 */
model Resource {
  /**
   * Azure resource Id
   */
  @visibility("read")
  id?: string;

  /**
   * Azure resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Azure resource name
   */
  @visibility("read")
  name?: string;
}

/**
 * An error response from the service.
 */
@error
model AlertProcessingRuleErrorResponse {
  /**
   * Details of error response.
   */
  error?: AlertProcessingRuleErrorResponseBody;
}

/**
 * Details of error response.
 */
model AlertProcessingRuleErrorResponseBody {
  /**
   * Error code, intended to be consumed programmatically.
   */
  code?: string;

  /**
   * Description of the error, intended for display in user interface.
   */
  message?: string;

  /**
   * Target of the particular error, for example name of the property.
   */
  target?: string;

  /**
   * A list of additional details about the error.
   */
  details?: AlertProcessingRuleErrorResponseBody[];
}

/**
 * Data contract for patch.
 */
model PatchObject {
  /**
   * Properties supported by patch operation.
   */
  properties?: PatchProperties;

  /**
   * Tags to be updated.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Alert processing rule properties supported by patch.
 */
model PatchProperties {
  /**
   * Indicates if the given alert processing rule is enabled or disabled.
   */
  enabled?: boolean;
}

/**
 * An error response from the service.
 */
@error
model AlertsManagementErrorResponse {
  /**
   * Details of error response.
   */
  error?: AlertsManagementErrorResponseBody;
}

/**
 * Details of error response.
 */
model AlertsManagementErrorResponseBody {
  /**
   * Error code, intended to be consumed programmatically.
   */
  code?: string;

  /**
   * Description of the error, intended for display in user interface.
   */
  message?: string;

  /**
   * Target of the particular error, for example name of the property.
   */
  target?: string;

  /**
   * A list of additional details about the error.
   */
  details?: AlertsManagementErrorResponseBody[];
}

/**
 * alert meta data information.
 */
model AlertsMetaData {
  /**
   * alert meta data property bag
   */
  properties?: AlertsMetaDataProperties;
}

/**
 * alert meta data property bag
 */
@discriminator("metadataIdentifier")
model AlertsMetaDataProperties {}

/**
 * Alert property bag
 */
model AlertProperties {
  /**
   * This object contains consistent fields across different monitor services.
   */
  essentials?: Essentials;

  /**
   * Information specific to the monitor service that gives more contextual details about the alert.
   */
  @visibility("read")
  context?: Record<unknown>;

  /**
   * Config which would be used for displaying the data in portal.
   */
  @visibility("read")
  egressConfig?: Record<unknown>;
}

/**
 * This object contains consistent fields across different monitor services.
 */
model Essentials {
  /**
   * Severity of alert Sev0 being highest and Sev4 being lowest.
   */
  @visibility("read")
  severity?: Severity;

  /**
   * The type of signal the alert is based on, which could be metrics, logs or activity logs.
   */
  @visibility("read")
  signalType?: SignalType;

  /**
   * Alert object state, which can be modified by the user.
   */
  @visibility("read")
  alertState?: AlertState;

  /**
   * Condition of the rule at the monitor service. It represents whether the underlying conditions have crossed the defined alert rule thresholds.
   */
  @visibility("read")
  monitorCondition?: MonitorCondition;

  /**
   * Target ARM resource, on which alert got created.
   */
  targetResource?: string;

  /**
   * Name of the target ARM resource name, on which alert got created.
   */
  targetResourceName?: string;

  /**
   * Resource group of target ARM resource, on which alert got created.
   */
  targetResourceGroup?: string;

  /**
   * Resource type of target ARM resource, on which alert got created.
   */
  targetResourceType?: string;

  /**
   * Monitor service on which the rule(monitor) is set.
   */
  @visibility("read")
  monitorService?: MonitorService;

  /**
   * Rule(monitor) which fired alert instance. Depending on the monitor service,  this would be ARM id or name of the rule.
   */
  @visibility("read")
  alertRule?: string;

  /**
   * Unique Id created by monitor service for each alert instance. This could be used to track the issue at the monitor service, in case of Nagios, Zabbix, SCOM etc.
   */
  @visibility("read")
  sourceCreatedId?: string;

  /**
   * Unique Id of the smart group
   */
  @visibility("read")
  smartGroupId?: string;

  /**
   * Verbose reason describing the reason why this alert instance is added to a smart group
   */
  @visibility("read")
  smartGroupingReason?: string;

  /**
   * Creation time(ISO-8601 format) of alert instance.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * Last modification time(ISO-8601 format) of alert instance.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * Resolved time(ISO-8601 format) of alert instance. This will be updated when monitor service resolves the alert instance because the rule condition is no longer met.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  monitorConditionResolvedDateTime?: utcDateTime;

  /**
   * User who last modified the alert, in case of monitor service updates user would be 'system', otherwise name of the user.
   */
  @visibility("read")
  lastModifiedUserName?: string;

  /**
   * Action status
   */
  actionStatus?: ActionStatus;

  /**
   * Alert description.
   */
  description?: string;
}

/**
 * Action status
 */
model ActionStatus {
  /**
   * Value indicating whether alert is suppressed.
   */
  isSuppressed?: boolean;
}

/**
 * Alert Modification details
 */
model AlertModification extends Resource {
  /**
   * Properties of the alert modification item.
   */
  properties?: AlertModificationProperties;
}

/**
 * Properties of the alert modification item.
 */
model AlertModificationProperties {
  /**
   * Unique Id of the alert for which the history is being retrieved
   */
  @visibility("read")
  alertId?: string;

  /**
   * Modification details
   */
  modifications?: AlertModificationItem[];
}

/**
 * Alert modification item.
 */
model AlertModificationItem {
  /**
   * Reason for the modification
   */
  modificationEvent?: AlertModificationEvent;

  /**
   * Old value
   */
  oldValue?: string;

  /**
   * New value
   */
  newValue?: string;

  /**
   * Modified date and time
   */
  modifiedAt?: string;

  /**
   * Modified user details (Principal client name)
   */
  modifiedBy?: string;

  /**
   * Modification comments
   */
  comments?: string;

  /**
   * Description of the modification
   */
  description?: string;
}

/**
 * Summary of alerts based on the input filters and 'groupby' parameters.
 */
model AlertsSummary extends Resource {
  /**
   * Group the result set.
   */
  properties?: AlertsSummaryGroup;
}

/**
 * Group the result set.
 */
model AlertsSummaryGroup {
  /**
   * Total count of the result set.
   */
  total?: int64;

  /**
   * Total count of the smart groups.
   */
  smartGroupsCount?: int64;

  /**
   * Name of the field aggregated
   */
  groupedby?: string;

  /**
   * List of the items
   */
  values?: AlertsSummaryGroupItem[];
}

/**
 * Alerts summary group item
 */
model AlertsSummaryGroupItem {
  /**
   * Value of the aggregated field
   */
  name?: string;

  /**
   * Count of the aggregated field
   */
  count?: int64;

  /**
   * Name of the field aggregated
   */
  groupedby?: string;

  /**
   * List of the items
   */
  values?: AlertsSummaryGroupItem[];
}

/**
 * Properties of smart group.
 */
model SmartGroupProperties {
  /**
   * Total number of alerts in smart group
   */
  alertsCount?: int64;

  /**
   * Smart group state
   */
  @visibility("read")
  smartGroupState?: SmartGroupState;

  /**
   * Severity of smart group is the highest(Sev0 >... > Sev4) severity of all the alerts in the group.
   */
  @visibility("read")
  severity?: Severity;

  /**
   * Creation time of smart group. Date-Time in ISO-8601 format.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * Last updated time of smart group. Date-Time in ISO-8601 format.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * Last modified by user name.
   */
  @visibility("read")
  lastModifiedUserName?: string;

  /**
   * Summary of target resources in the smart group
   */
  resources?: SmartGroupAggregatedProperty[];

  /**
   * Summary of target resource types in the smart group
   */
  resourceTypes?: SmartGroupAggregatedProperty[];

  /**
   * Summary of target resource groups in the smart group
   */
  resourceGroups?: SmartGroupAggregatedProperty[];

  /**
   * Summary of monitorServices in the smart group
   */
  monitorServices?: SmartGroupAggregatedProperty[];

  /**
   * Summary of monitorConditions in the smart group
   */
  monitorConditions?: SmartGroupAggregatedProperty[];

  /**
   * Summary of alertStates in the smart group
   */
  alertStates?: SmartGroupAggregatedProperty[];

  /**
   * Summary of alertSeverities in the smart group
   */
  alertSeverities?: SmartGroupAggregatedProperty[];

  /**
   * The URI to fetch the next page of alerts. Call ListNext() with this URI to fetch the next page alerts.
   */
  nextLink?: string;
}

/**
 * Aggregated property of each type
 */
model SmartGroupAggregatedProperty {
  /**
   * Name of the type.
   */
  name?: string;

  /**
   * Total number of items of type.
   */
  count?: int64;
}

/**
 * An error response from the service.
 */
@error
model SmartGroupErrorResponse {
  /**
   * Details of error response.
   */
  error?: SmartGroupErrorResponseBody;
}

/**
 * Details of error response.
 */
model SmartGroupErrorResponseBody {
  /**
   * Error code, intended to be consumed programmatically.
   */
  code?: string;

  /**
   * Description of the error, intended for display in user interface.
   */
  message?: string;

  /**
   * Target of the particular error, for example name of the property.
   */
  target?: string;

  /**
   * A list of additional details about the error.
   */
  details?: SmartGroupErrorResponseBody[];
}

/**
 * Alert Modification details
 */
model SmartGroupModification extends Resource {
  /**
   * Properties of the smartGroup modification item.
   */
  properties?: SmartGroupModificationProperties;
}

/**
 * Properties of the smartGroup modification item.
 */
model SmartGroupModificationProperties {
  /**
   * Unique Id of the smartGroup for which the history is being retrieved
   */
  @visibility("read")
  smartGroupId?: string;

  /**
   * Modification details
   */
  modifications?: SmartGroupModificationItem[];

  /**
   * URL to fetch the next set of results.
   */
  nextLink?: string;
}

/**
 * smartGroup modification item.
 */
model SmartGroupModificationItem {
  /**
   * Reason for the modification
   */
  modificationEvent?: SmartGroupModificationEvent;

  /**
   * Old value
   */
  oldValue?: string;

  /**
   * New value
   */
  newValue?: string;

  /**
   * Modified date and time
   */
  modifiedAt?: string;

  /**
   * Modified user details (Principal client name)
   */
  modifiedBy?: string;

  /**
   * Modification comments
   */
  comments?: string;

  /**
   * Description of the modification
   */
  description?: string;
}

/**
 * Daily recurrence object.
 */
model DailyRecurrence extends Recurrence {
  /**
   * Specifies when the recurrence should be applied.
   */
  recurrenceType: "Daily";
}

/**
 * Weekly recurrence object.
 */
model WeeklyRecurrence extends Recurrence {
  /**
   * Specifies the values for weekly recurrence pattern.
   */
  daysOfWeek: DaysOfWeek[];

  /**
   * Specifies when the recurrence should be applied.
   */
  recurrenceType: "Weekly";
}

/**
 * Monthly recurrence object.
 */
model MonthlyRecurrence extends Recurrence {
  /**
   * Specifies the values for monthly recurrence pattern.
   */
  daysOfMonth: int32[];

  /**
   * Specifies when the recurrence should be applied.
   */
  recurrenceType: "Monthly";
}

/**
 * Add action groups to alert processing rule.
 */
model AddActionGroups extends Action {
  /**
   * List of action group Ids to add to alert processing rule.
   */
  actionGroupIds: string[];

  /**
   * Action that should be applied.
   */
  actionType: "AddActionGroups";
}

/**
 * Indicates if all action groups should be removed.
 */
model RemoveAllActionGroups extends Action {
  /**
   * Action that should be applied.
   */
  actionType: "RemoveAllActionGroups";
}

/**
 * Monitor service details
 */
model MonitorServiceList extends AlertsMetaDataProperties {
  /**
   * Array of operations
   */
  data: MonitorServiceDetails[];

  /**
   * Identification of the information to be retrieved by API call
   */
  metadataIdentifier: "MonitorServiceList";
}

/**
 * Details of a monitor service
 */
model MonitorServiceDetails {
  /**
   * Monitor service name
   */
  name?: string;

  /**
   * Monitor service display name
   */
  displayName?: string;
}
