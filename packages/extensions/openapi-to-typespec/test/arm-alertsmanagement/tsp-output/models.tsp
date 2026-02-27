import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.AlertsManagement;

/** Field for a given condition. */
union Field {
  string,

  /** Severity */
  Severity: "Severity",

  /** MonitorService */
  MonitorService: "MonitorService",

  /** MonitorCondition */
  MonitorCondition: "MonitorCondition",

  /** SignalType */
  SignalType: "SignalType",

  /** TargetResourceType */
  TargetResourceType: "TargetResourceType",

  /** TargetResource */
  TargetResource: "TargetResource",

  /** TargetResourceGroup */
  TargetResourceGroup: "TargetResourceGroup",

  /** AlertRuleId */
  AlertRuleId: "AlertRuleId",

  /** AlertRuleName */
  AlertRuleName: "AlertRuleName",

  /** Description */
  Description: "Description",

  /** AlertContext */
  AlertContext: "AlertContext",
}

/** Operator for a given condition. */
union Operator {
  string,

  /** Equals */
  Equals: "Equals",

  /** NotEquals */
  NotEquals: "NotEquals",

  /** Contains */
  Contains: "Contains",

  /** DoesNotContain */
  DoesNotContain: "DoesNotContain",
}

/** Specifies when the recurrence should be applied. */
union RecurrenceType {
  string,

  /** Daily */
  Daily: "Daily",

  /** Weekly */
  Weekly: "Weekly",

  /** Monthly */
  Monthly: "Monthly",
}

/** Action that should be applied. */
union ActionType {
  string,

  /** AddActionGroups */
  AddActionGroups: "AddActionGroups",

  /** RemoveAllActionGroups */
  RemoveAllActionGroups: "RemoveAllActionGroups",
}

/** The type of identity that created the resource. */
union CreatedByType {
  string,

  /** User */
  User: "User",

  /** Application */
  Application: "Application",

  /** ManagedIdentity */
  ManagedIdentity: "ManagedIdentity",

  /** Key */
  Key: "Key",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union Identifier {
  string,

  /** MonitorServiceList */
  MonitorServiceList: "MonitorServiceList",
}

/** Identification of the information to be retrieved by API call */
union MetadataIdentifier {
  string,

  /** MonitorServiceList */
  MonitorServiceList: "MonitorServiceList",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union MonitorService {
  string,

  /** Application Insights */
  `Application Insights`: "Application Insights",

  /** ActivityLog Administrative */
  `ActivityLog Administrative`: "ActivityLog Administrative",

  /** ActivityLog Security */
  `ActivityLog Security`: "ActivityLog Security",

  /** ActivityLog Recommendation */
  `ActivityLog Recommendation`: "ActivityLog Recommendation",

  /** ActivityLog Policy */
  `ActivityLog Policy`: "ActivityLog Policy",

  /** ActivityLog Autoscale */
  `ActivityLog Autoscale`: "ActivityLog Autoscale",

  /** Log Analytics */
  `Log Analytics`: "Log Analytics",

  /** Nagios */
  Nagios: "Nagios",

  /** Platform */
  Platform: "Platform",

  /** SCOM */
  SCOM: "SCOM",

  /** ServiceHealth */
  ServiceHealth: "ServiceHealth",

  /** SmartDetector */
  SmartDetector: "SmartDetector",

  /** VM Insights */
  `VM Insights`: "VM Insights",

  /** Zabbix */
  Zabbix: "Zabbix",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union MonitorCondition {
  string,

  /** Fired */
  Fired: "Fired",

  /** Resolved */
  Resolved: "Resolved",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union Severity {
  string,

  /** Sev0 */
  Sev0: "Sev0",

  /** Sev1 */
  Sev1: "Sev1",

  /** Sev2 */
  Sev2: "Sev2",

  /** Sev3 */
  Sev3: "Sev3",

  /** Sev4 */
  Sev4: "Sev4",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union AlertState {
  string,

  /** New */
  New: "New",

  /** Acknowledged */
  Acknowledged: "Acknowledged",

  /** Closed */
  Closed: "Closed",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union AlertsSortByFields {
  string,

  /** name */
  name: "name",

  /** severity */
  severity: "severity",

  /** alertState */
  alertState: "alertState",

  /** monitorCondition */
  monitorCondition: "monitorCondition",

  /** targetResource */
  targetResource: "targetResource",

  /** targetResourceName */
  targetResourceName: "targetResourceName",

  /** targetResourceGroup */
  targetResourceGroup: "targetResourceGroup",

  /** targetResourceType */
  targetResourceType: "targetResourceType",

  /** startDateTime */
  startDateTime: "startDateTime",

  /** lastModifiedDateTime */
  lastModifiedDateTime: "lastModifiedDateTime",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union SortOrder {
  string,

  /** asc */
  asc: "asc",

  /** desc */
  desc: "desc",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union TimeRange {
  string,

  /** 1h */
  `1h`: "1h",

  /** 1d */
  `1d`: "1d",

  /** 7d */
  `7d`: "7d",

  /** 30d */
  `30d`: "30d",
}

/** The type of signal the alert is based on, which could be metrics, logs or activity logs. */
union SignalType {
  string,

  /** Metric */
  Metric: "Metric",

  /** Log */
  Log: "Log",

  /** Unknown */
  Unknown: "Unknown",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union AlertsSummaryGroupByFields {
  string,

  /** severity */
  severity: "severity",

  /** alertState */
  alertState: "alertState",

  /** monitorCondition */
  monitorCondition: "monitorCondition",

  /** monitorService */
  monitorService: "monitorService",

  /** signalType */
  signalType: "signalType",

  /** alertRule */
  alertRule: "alertRule",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union SmartGroupsSortByFields {
  string,

  /** alertsCount */
  alertsCount: "alertsCount",

  /** state */
  state: "state",

  /** severity */
  severity: "severity",

  /** startDateTime */
  startDateTime: "startDateTime",

  /** lastModifiedDateTime */
  lastModifiedDateTime: "lastModifiedDateTime",
}

/** Smart group state */
union SmartGroupState {
  string,

  /** New */
  New: "New",

  /** Acknowledged */
  Acknowledged: "Acknowledged",

  /** Closed */
  Closed: "Closed",
}

/** Days of week. */
union DaysOfWeek {
  string,

  /** Sunday */
  Sunday: "Sunday",

  /** Monday */
  Monday: "Monday",

  /** Tuesday */
  Tuesday: "Tuesday",

  /** Wednesday */
  Wednesday: "Wednesday",

  /** Thursday */
  Thursday: "Thursday",

  /** Friday */
  Friday: "Friday",

  /** Saturday */
  Saturday: "Saturday",
}

/** Reason for the modification */
#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"
enum AlertModificationEvent {
  /** AlertCreated */
  AlertCreated,

  /** StateChange */
  StateChange,

  /** MonitorConditionChange */
  MonitorConditionChange,

  /** SeverityChange */
  SeverityChange,

  /** ActionRuleTriggered */
  ActionRuleTriggered,

  /** ActionRuleSuppressed */
  ActionRuleSuppressed,

  /** ActionsTriggered */
  ActionsTriggered,

  /** ActionsSuppressed */
  ActionsSuppressed,

  /** ActionsFailed */
  ActionsFailed,
}

/** Reason for the modification */
#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"
enum SmartGroupModificationEvent {
  /** SmartGroupCreated */
  SmartGroupCreated,

  /** StateChange */
  StateChange,

  /** AlertAdded */
  AlertAdded,

  /** AlertRemoved */
  AlertRemoved,
}

/** List of alert processing rules. */
model AlertProcessingRulesList is Azure.Core.Page<AlertProcessingRule>;

/** Alert processing rule properties defining scopes, conditions and scheduling logic for alert processing rule. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model AlertProcessingRuleProperties {
  /** Scopes on which alert processing rule will apply. */
  scopes: string[];

  /** Conditions on which alerts will be filtered. */
  conditions?: Condition[];

  /** Scheduling for alert processing rule. */
  schedule?: Schedule;

  /** Actions to be applied. */
  actions: Action[];

  /** Description of alert processing rule. */
  description?: string;

  /** Indicates if the given alert processing rule is enabled or disabled. */
  enabled?: boolean = true;
}

/** Condition to trigger an alert processing rule. */
model Condition {
  /** Field for a given condition. */
  field?: Field;

  /** Operator for a given condition. */
  operator?: Operator;

  /** List of values to match for a given condition. */
  values?: string[];
}

/** Scheduling configuration for a given alert processing rule. */
model Schedule {
  /** Scheduling effective from time. Date-Time in ISO-8601 format without timezone suffix. */
  @pattern("^(?:(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?))$")
  effectiveFrom?: string;

  /** Scheduling effective until time. Date-Time in ISO-8601 format without timezone suffix. */
  @pattern("^(?:(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?))$")
  effectiveUntil?: string;

  /** Scheduling time zone. */
  timeZone?: string;

  /** List of recurrences. */
  recurrences?: Recurrence[];
}

/** Recurrence object. */
@discriminator("recurrenceType")
model Recurrence {
  /** Specifies when the recurrence should be applied. */
  recurrenceType: RecurrenceType;

  /** Start time for recurrence. */
  startTime?: plainTime;

  /** End time for recurrence. */
  endTime?: plainTime;
}

/** Action to be applied. */
@discriminator("actionType")
model Action {
  /** Action that should be applied. */
  actionType: ActionType;
}

/** An azure managed resource object. */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model ManagedResource extends Resource {
  /** Resource location */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  location: string;

  /** Resource tags */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/** An azure resource object */
model Resource {
  /** Azure resource Id */
  @visibility(Lifecycle.Read)
  id?: string;

  /** Azure resource type */
  @visibility(Lifecycle.Read)
  type?: string;

  /** Azure resource name */
  @visibility(Lifecycle.Read)
  name?: string;
}

/** An error response from the service. */
@error
model AlertProcessingRuleErrorResponse {
  /** Details of error response. */
  error?: AlertProcessingRuleErrorResponseBody;
}

/** Details of error response. */
model AlertProcessingRuleErrorResponseBody {
  /** Error code, intended to be consumed programmatically. */
  code?: string;

  /** Description of the error, intended for display in user interface. */
  message?: string;

  /** Target of the particular error, for example name of the property. */
  target?: string;

  /** A list of additional details about the error. */
  details?: AlertProcessingRuleErrorResponseBody[];
}

/** Data contract for patch. */
model PatchObject {
  /** Properties supported by patch operation. */
  properties?: PatchProperties;

  /** Tags to be updated. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/** Alert processing rule properties supported by patch. */
model PatchProperties {
  /** Indicates if the given alert processing rule is enabled or disabled. */
  enabled?: boolean;
}

/** Operation provided by provider */
model Operation {
  /** Name of the operation */
  name?: string;

  /** Properties of the operation */
  display?: OperationDisplay;

  /** Origin of the operation */
  origin?: string;
}

/** Properties of the operation */
model OperationDisplay {
  /** Provider name */
  provider?: string;

  /** Resource name */
  resource?: string;

  /** Operation name */
  operation?: string;

  /** Description of the operation */
  description?: string;
}

/** An error response from the service. */
@error
model AlertsManagementErrorResponse {
  /** Details of error response. */
  error?: AlertsManagementErrorResponseBody;
}

/** Details of error response. */
model AlertsManagementErrorResponseBody {
  /** Error code, intended to be consumed programmatically. */
  code?: string;

  /** Description of the error, intended for display in user interface. */
  message?: string;

  /** Target of the particular error, for example name of the property. */
  target?: string;

  /** A list of additional details about the error. */
  details?: AlertsManagementErrorResponseBody[];
}

/** alert meta data information. */
model AlertsMetaData {
  /** alert meta data property bag */
  properties?: AlertsMetaDataProperties;
}

/** alert meta data property bag */
@discriminator("metadataIdentifier")
model AlertsMetaDataProperties {
  /** Identification of the information to be retrieved by API call */
  metadataIdentifier: MetadataIdentifier;
}

/** List the alerts. */
model AlertsList is Azure.Core.Page<Alert>;

/** Alert property bag */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model AlertProperties {
  /** This object contains consistent fields across different monitor services. */
  essentials?: Essentials;

  /** Information specific to the monitor service that gives more contextual details about the alert. */
  @visibility(Lifecycle.Read)
  context?: unknown;

  /** Config which would be used for displaying the data in portal. */
  @visibility(Lifecycle.Read)
  egressConfig?: unknown;
}

/** This object contains consistent fields across different monitor services. */
model Essentials {
  /** Severity of alert Sev0 being highest and Sev4 being lowest. */
  @visibility(Lifecycle.Read)
  severity?: Severity;

  /** The type of signal the alert is based on, which could be metrics, logs or activity logs. */
  @visibility(Lifecycle.Read)
  signalType?: SignalType;

  /** Alert object state, which can be modified by the user. */
  @visibility(Lifecycle.Read)
  alertState?: AlertState;

  /** Condition of the rule at the monitor service. It represents whether the underlying conditions have crossed the defined alert rule thresholds. */
  @visibility(Lifecycle.Read)
  monitorCondition?: MonitorCondition;

  /** Target ARM resource, on which alert got created. */
  targetResource?: string;

  /** Name of the target ARM resource name, on which alert got created. */
  targetResourceName?: string;

  /** Resource group of target ARM resource, on which alert got created. */
  targetResourceGroup?: string;

  /** Resource type of target ARM resource, on which alert got created. */
  targetResourceType?: string;

  /** Monitor service on which the rule(monitor) is set. */
  @visibility(Lifecycle.Read)
  monitorService?: MonitorService;

  /** Rule(monitor) which fired alert instance. Depending on the monitor service,  this would be ARM id or name of the rule. */
  @visibility(Lifecycle.Read)
  alertRule?: string;

  /** Unique Id created by monitor service for each alert instance. This could be used to track the issue at the monitor service, in case of Nagios, Zabbix, SCOM etc. */
  @visibility(Lifecycle.Read)
  sourceCreatedId?: string;

  /** Unique Id of the smart group */
  @visibility(Lifecycle.Read)
  smartGroupId?: string;

  /** Verbose reason describing the reason why this alert instance is added to a smart group */
  @visibility(Lifecycle.Read)
  smartGroupingReason?: string;

  /** Creation time(ISO-8601 format) of alert instance. */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /** Last modification time(ISO-8601 format) of alert instance. */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /** Resolved time(ISO-8601 format) of alert instance. This will be updated when monitor service resolves the alert instance because the rule condition is no longer met. */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  monitorConditionResolvedDateTime?: utcDateTime;

  /** User who last modified the alert, in case of monitor service updates user would be 'system', otherwise name of the user. */
  @visibility(Lifecycle.Read)
  lastModifiedUserName?: string;

  /** Action status */
  actionStatus?: ActionStatus;

  /** Alert description. */
  description?: string;
}

/** Action status */
model ActionStatus {
  /** Value indicating whether alert is suppressed. */
  isSuppressed?: boolean;
}

/** Alert Modification details */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model AlertModification extends Resource {
  /** Properties of the alert modification item. */
  properties?: AlertModificationProperties;
}

/** Properties of the alert modification item. */
model AlertModificationProperties {
  /** Unique Id of the alert for which the history is being retrieved */
  @visibility(Lifecycle.Read)
  alertId?: string;

  /** Modification details */
  modifications?: AlertModificationItem[];
}

/** Alert modification item. */
model AlertModificationItem {
  /** Reason for the modification */
  modificationEvent?: AlertModificationEvent;

  /** Old value */
  oldValue?: string;

  /** New value */
  newValue?: string;

  /** Modified date and time */
  modifiedAt?: string;

  /** Modified user details (Principal client name) */
  modifiedBy?: string;

  /** Modification comments */
  comments?: string;

  /** Description of the modification */
  description?: string;
}

/** Summary of alerts based on the input filters and 'groupby' parameters. */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model AlertsSummary extends Resource {
  /** Group the result set. */
  properties?: AlertsSummaryGroup;
}

/** Group the result set. */
model AlertsSummaryGroup {
  /** Total count of the result set. */
  total?: int64;

  /** Total count of the smart groups. */
  smartGroupsCount?: int64;

  /** Name of the field aggregated */
  groupedby?: string;

  /** List of the items */
  values?: AlertsSummaryGroupItem[];
}

/** Alerts summary group item */
model AlertsSummaryGroupItem {
  /** Value of the aggregated field */
  name?: string;

  /** Count of the aggregated field */
  count?: int64;

  /** Name of the field aggregated */
  groupedby?: string;

  /** List of the items */
  values?: AlertsSummaryGroupItem[];
}

/** List the alerts. */
model SmartGroupsList is Azure.Core.Page<SmartGroup>;

/** Properties of smart group. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
model SmartGroupProperties {
  /** Total number of alerts in smart group */
  alertsCount?: int64;

  /** Smart group state */
  @visibility(Lifecycle.Read)
  smartGroupState?: SmartGroupState;

  /** Severity of smart group is the highest(Sev0 >... > Sev4) severity of all the alerts in the group. */
  @visibility(Lifecycle.Read)
  severity?: Severity;

  /** Creation time of smart group. Date-Time in ISO-8601 format. */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /** Last updated time of smart group. Date-Time in ISO-8601 format. */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /** Last modified by user name. */
  @visibility(Lifecycle.Read)
  lastModifiedUserName?: string;

  /** Summary of target resources in the smart group */
  resources?: SmartGroupAggregatedProperty[];

  /** Summary of target resource types in the smart group */
  resourceTypes?: SmartGroupAggregatedProperty[];

  /** Summary of target resource groups in the smart group */
  resourceGroups?: SmartGroupAggregatedProperty[];

  /** Summary of monitorServices in the smart group */
  monitorServices?: SmartGroupAggregatedProperty[];

  /** Summary of monitorConditions in the smart group */
  monitorConditions?: SmartGroupAggregatedProperty[];

  /** Summary of alertStates in the smart group */
  alertStates?: SmartGroupAggregatedProperty[];

  /** Summary of alertSeverities in the smart group */
  alertSeverities?: SmartGroupAggregatedProperty[];

  /** The URI to fetch the next page of alerts. Call ListNext() with this URI to fetch the next page alerts. */
  nextLink?: string;
}

/** Aggregated property of each type */
model SmartGroupAggregatedProperty {
  /** Name of the type. */
  name?: string;

  /** Total number of items of type. */
  count?: int64;
}

/** An error response from the service. */
@error
model SmartGroupErrorResponse {
  /** Details of error response. */
  error?: SmartGroupErrorResponseBody;
}

/** Details of error response. */
model SmartGroupErrorResponseBody {
  /** Error code, intended to be consumed programmatically. */
  code?: string;

  /** Description of the error, intended for display in user interface. */
  message?: string;

  /** Target of the particular error, for example name of the property. */
  target?: string;

  /** A list of additional details about the error. */
  details?: SmartGroupErrorResponseBody[];
}

/** Alert Modification details */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model SmartGroupModification extends Resource {
  /** Properties of the smartGroup modification item. */
  properties?: SmartGroupModificationProperties;
}

/** Properties of the smartGroup modification item. */
model SmartGroupModificationProperties {
  /** Unique Id of the smartGroup for which the history is being retrieved */
  @visibility(Lifecycle.Read)
  smartGroupId?: string;

  /** Modification details */
  modifications?: SmartGroupModificationItem[];

  /** URL to fetch the next set of results. */
  nextLink?: string;
}

/** smartGroup modification item. */
model SmartGroupModificationItem {
  /** Reason for the modification */
  modificationEvent?: SmartGroupModificationEvent;

  /** Old value */
  oldValue?: string;

  /** New value */
  newValue?: string;

  /** Modified date and time */
  modifiedAt?: string;

  /** Modified user details (Principal client name) */
  modifiedBy?: string;

  /** Modification comments */
  comments?: string;

  /** Description of the modification */
  description?: string;
}

/** Daily recurrence object. */
model DailyRecurrence extends Recurrence {
  /** Specifies when the recurrence should be applied. */
  recurrenceType: "Daily";
}

/** Weekly recurrence object. */
model WeeklyRecurrence extends Recurrence {
  /** Specifies the values for weekly recurrence pattern. */
  daysOfWeek: DaysOfWeek[];

  /** Specifies when the recurrence should be applied. */
  recurrenceType: "Weekly";
}

/** Monthly recurrence object. */
model MonthlyRecurrence extends Recurrence {
  /** Specifies the values for monthly recurrence pattern. */
  daysOfMonth: int32[];

  /** Specifies when the recurrence should be applied. */
  recurrenceType: "Monthly";
}

/** Add action groups to alert processing rule. */
model AddActionGroups extends Action {
  /** List of action group Ids to add to alert processing rule. */
  actionGroupIds: string[];

  /** Action that should be applied. */
  actionType: "AddActionGroups";
}

/** Indicates if all action groups should be removed. */
model RemoveAllActionGroups extends Action {
  /** Action that should be applied. */
  actionType: "RemoveAllActionGroups";
}

/** Monitor service details */
model MonitorServiceList extends AlertsMetaDataProperties {
  /** Array of operations */
  data: MonitorServiceDetails[];

  /** Identification of the information to be retrieved by API call */
  metadataIdentifier: "MonitorServiceList";
}

/** Details of a monitor service */
model MonitorServiceDetails {
  /** Monitor service name */
  name?: string;

  /** Monitor service display name */
  displayName?: string;
}
