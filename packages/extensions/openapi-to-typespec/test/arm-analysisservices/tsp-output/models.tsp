import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.Analysis;

/**
 * The current state of Analysis Services resource. The state is to indicate more states outside of resource provisioning.
 */
union State {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Deleting: "Deleting",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Succeeded: "Succeeded",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Failed: "Failed",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Paused: "Paused",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Suspended: "Suspended",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Provisioning: "Provisioning",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Updating: "Updating",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Suspending: "Suspending",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Pausing: "Pausing",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Resuming: "Resuming",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Preparing: "Preparing",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Scaling: "Scaling",
}

/**
 * The current deployment state of Analysis Services resource. The provisioningState is to indicate states for resource provisioning.
 */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "For backward compatibility"
union ProvisioningState {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Deleting: "Deleting",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Succeeded: "Succeeded",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Failed: "Failed",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Paused: "Paused",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Suspended: "Suspended",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Provisioning: "Provisioning",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Updating: "Updating",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Suspending: "Suspending",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Pausing: "Pausing",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Resuming: "Resuming",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Preparing: "Preparing",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Scaling: "Scaling",
}

/**
 * The name of the Azure pricing tier to which the SKU applies.
 */
union SkuTier {
  string,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Development: "Development",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Basic: "Basic",
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  Standard: "Standard",
}

/**
 * The managed mode of the server (0 = not managed, 1 = managed).
 */
union ManagedMode {
  integer,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  `0`: 0,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  `1`: 1,
}

/**
 * The server monitor mode for AS server
 */
union ServerMonitorMode {
  integer,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  `0`: 0,
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  `1`: 1,
}

/**
 * How the read-write server's participation in the query pool is controlled.<br/>It can have the following values: <ul><li>readOnly - indicates that the read-write server is intended not to participate in query operations</li><li>all - indicates that the read-write server can participate in query operations</li></ul>Specifying readOnly when capacity is 1 results in error.
 */
#suppress "@azure-tools/typespec-azure-core/no-enum" "For backward compatibility"
enum ConnectionMode {
  All,
  ReadOnly,
}

/**
 * Properties of Analysis Services resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model AnalysisServicesServerProperties
  extends AnalysisServicesServerMutableProperties {
  /**
   * The current state of Analysis Services resource. The state is to indicate more states outside of resource provisioning.
   */
  @visibility(Lifecycle.Read)
  state?: State;

  /**
   * The current deployment state of Analysis Services resource. The provisioningState is to indicate states for resource provisioning.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * The full name of the Analysis Services resource.
   */
  @visibility(Lifecycle.Read)
  serverFullName?: string;

  /**
   * The SKU of the Analysis Services resource.
   */
  sku?: ResourceSku;
}

/**
 * Represents the SKU name and Azure pricing tier for Analysis Services resource.
 */
model ResourceSku {
  /**
   * Name of the SKU level.
   */
  name: string;

  /**
   * The name of the Azure pricing tier to which the SKU applies.
   */
  tier?: SkuTier;

  /**
   * The number of instances in the read only query pool.
   */
  @maxValue(8)
  @minValue(1)
  capacity?: int32 = 1;
}

/**
 * An object that represents a set of mutable Analysis Services resource properties.
 */
model AnalysisServicesServerMutableProperties {
  /**
   * A collection of AS server administrators
   */
  asAdministrators?: ServerAdministrators;

  /**
   * The SAS container URI to the backup container.
   */
  backupBlobContainerUri?: string;

  /**
   * The gateway details configured for the AS server.
   */
  gatewayDetails?: GatewayDetails;

  /**
   * The firewall settings for the AS server.
   */
  ipV4FirewallSettings?: IPv4FirewallSettings;

  /**
   * How the read-write server's participation in the query pool is controlled.<br/>It can have the following values: <ul><li>readOnly - indicates that the read-write server is intended not to participate in query operations</li><li>all - indicates that the read-write server can participate in query operations</li></ul>Specifying readOnly when capacity is 1 results in error.
   */
  querypoolConnectionMode?: ConnectionMode = ConnectionMode.All;

  /**
   * The managed mode of the server (0 = not managed, 1 = managed).
   */
  managedMode?: ManagedMode;

  /**
   * The server monitor mode for AS server
   */
  serverMonitorMode?: ServerMonitorMode;
}

/**
 * An array of administrator user identities.
 */
model ServerAdministrators {
  /**
   * An array of administrator user identities.
   */
  members?: string[];
}

/**
 * The gateway details.
 */
model GatewayDetails {
  /**
   * Gateway resource to be associated with the server.
   */
  gatewayResourceId?: string;

  /**
   * Gateway object id from in the DMTS cluster for the gateway resource.
   */
  @visibility(Lifecycle.Read)
  gatewayObjectId?: string;

  /**
   * Uri of the DMTS cluster.
   */
  @visibility(Lifecycle.Read)
  dmtsClusterUri?: string;
}

/**
 * An array of firewall rules.
 */
model IPv4FirewallSettings {
  /**
   * An array of firewall rules.
   */
  @OpenAPI.extension("x-ms-identifiers", #["firewallRuleName"])
  firewallRules?: IPv4FirewallRule[];

  /**
   * The indicator of enabling PBI service.
   */
  enablePowerBIService?: boolean;
}

/**
 * The detail of firewall rule.
 */
model IPv4FirewallRule {
  /**
   * The rule name.
   */
  firewallRuleName?: string;

  /**
   * The start range of IPv4.
   */
  rangeStart?: string;

  /**
   * The end range of IPv4.
   */
  rangeEnd?: string;
}

/**
 * Represents an instance of an Analysis Services resource.
 */
model Resource {
  /**
   * An identifier that represents the Analysis Services resource.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * The name of the Analysis Services resource.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * The type of the Analysis Services resource.
   */
  @visibility(Lifecycle.Read)
  type?: string;

  /**
   * Location of the Analysis Services resource.
   */
  @visibility(Lifecycle.Read, Lifecycle.Create)
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  location: string;

  /**
   * The SKU of the Analysis Services resource.
   */
  sku: ResourceSku;

  /**
   * Key-value pairs of additional resource provisioning properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Describes the format of Error response.
 */
@error
model ErrorResponse {
  /**
   * The error object
   */
  error?: ErrorDetail;
}

/**
 * The error detail.
 */
model ErrorDetail {
  /**
   * The error code.
   */
  @visibility(Lifecycle.Read)
  code?: string;

  /**
   * The error message.
   */
  @visibility(Lifecycle.Read)
  message?: string;

  /**
   * The error target.
   */
  @visibility(Lifecycle.Read)
  target?: string;

  /**
   * The error sub code
   */
  @visibility(Lifecycle.Read)
  subCode?: int32;

  /**
   * The http status code
   */
  @visibility(Lifecycle.Read)
  httpStatusCode?: int32;

  /**
   * the timestamp for the error.
   */
  @visibility(Lifecycle.Read)
  timeStamp?: string;

  /**
   * The error details.
   */
  @visibility(Lifecycle.Read)
  @OpenAPI.extension("x-ms-identifiers", #["message", "target"])
  details?: ErrorDetail[];

  /**
   * The error additional info.
   */
  @visibility(Lifecycle.Read)
  @OpenAPI.extension("x-ms-identifiers", #[])
  additionalInfo?: ErrorAdditionalInfo[];
}

/**
 * The resource management error additional info.
 */
model ErrorAdditionalInfo {
  /**
   * The additional info type.
   */
  @visibility(Lifecycle.Read)
  type?: string;

  /**
   * The additional info.
   */
  @visibility(Lifecycle.Read)
  info?: Record<unknown>;
}

/**
 * Provision request specification
 */
model AnalysisServicesServerUpdateParameters {
  /**
   * The SKU of the Analysis Services resource.
   */
  sku?: ResourceSku;

  /**
   * Key-value pairs of additional provisioning properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * Properties of the provision operation request.
   */
  #suppress "@azure-tools/typespec-azure-core/no-private-usage" "For backward compatibility"
  @Azure.ResourceManager.Private.conditionalClientFlatten
  properties?: AnalysisServicesServerMutableProperties;
}

/**
 * An array of Analysis Services resources.
 */
model AnalysisServicesServers {
  /**
   * An array of Analysis Services resources.
   */
  @pageItems
  value: AnalysisServicesServer[];
}

/**
 * An object that represents enumerating SKUs for new resources.
 */
model SkuEnumerationForNewResourceResult {
  /**
   * The collection of available SKUs for new resources.
   */
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  value?: ResourceSku[];
}

/**
 * An object that represents enumerating SKUs for existing resources.
 */
model SkuEnumerationForExistingResourceResult {
  /**
   * The collection of available SKUs for existing resources.
   */
  @pageItems
  @OpenAPI.extension("x-ms-identifiers", #["sku/name"])
  value?: SkuDetailsForExistingResource[];
}

/**
 * An object that represents SKU details for existing resources.
 */
model SkuDetailsForExistingResource {
  /**
   * The SKU in SKU details for existing resources.
   */
  sku?: ResourceSku;

  /**
   * The resource type.
   */
  resourceType?: string;
}

/**
 * Status of gateway is live.
 */
model GatewayListStatusLive {
  /**
   * Live message of list gateway. Status: 0 - Live
   */
  status?: 0;
}

/**
 * Status of gateway is error.
 */
@error
model GatewayListStatusError {
  /**
   * Error of the list gateway status.
   */
  error?: ErrorDetail;
}

/**
 * Details of server name request body.
 */
model CheckServerNameAvailabilityParameters {
  /**
   * Name for checking availability.
   */
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9]*$")
  name?: string;

  /**
   * The resource type of azure analysis services.
   */
  type?: string = "Microsoft.AnalysisServices/servers";
}

/**
 * The checking result of server name availability.
 */
model CheckServerNameAvailabilityResult {
  /**
   * Indicator of available of the server name.
   */
  nameAvailable?: boolean;

  /**
   * The reason of unavailability.
   */
  reason?: string;

  /**
   * The detailed message of the request unavailability.
   */
  message?: string;
}

/**
 * A Consumption REST API operation.
 */
model Operation {
  /**
   * Operation name: {provider}/{resource}/{operation}.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * The object that represents the operation.
   */
  display?: OperationDisplay;

  /**
   * The origin
   */
  @visibility(Lifecycle.Read)
  origin?: string;

  /**
   * Additional properties to expose performance metrics to shoebox.
   */
  properties?: OperationProperties;
}

/**
 * The object that represents the operation.
 */
model OperationDisplay {
  /**
   * Service provider: Microsoft.Consumption.
   */
  @visibility(Lifecycle.Read)
  provider?: string;

  /**
   * Resource on which the operation is performed: UsageDetail, etc.
   */
  @visibility(Lifecycle.Read)
  resource?: string;

  /**
   * Operation type: Read, write, delete, etc.
   */
  @visibility(Lifecycle.Read)
  operation?: string;

  /**
   * Description of the operation object.
   */
  @visibility(Lifecycle.Read)
  description?: string;
}

/**
 * Additional properties to expose performance metrics to shoebox.
 */
model OperationProperties {
  /**
   * Performance metrics to shoebox.
   */
  serviceSpecification?: OperationPropertiesServiceSpecification;
}

/**
 * Performance metrics to shoebox.
 */
model OperationPropertiesServiceSpecification {
  /**
   * The metric specifications.
   */
  @visibility(Lifecycle.Read)
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  metricSpecifications?: MetricSpecifications[];

  /**
   * The log specifications.
   */
  @visibility(Lifecycle.Read)
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  logSpecifications?: LogSpecifications[];
}

/**
 * Available operation metric specification for exposing performance metrics to shoebox.
 */
model MetricSpecifications {
  /**
   * The name of metric.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * The displayed name of metric.
   */
  @visibility(Lifecycle.Read)
  displayName?: string;

  /**
   * The displayed description of metric.
   */
  @visibility(Lifecycle.Read)
  displayDescription?: string;

  /**
   * The unit of the metric.
   */
  @visibility(Lifecycle.Read)
  unit?: string;

  /**
   * The aggregation type of metric.
   */
  @visibility(Lifecycle.Read)
  aggregationType?: string;

  /**
   * The dimensions of metric.
   */
  @visibility(Lifecycle.Read)
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  dimensions?: MetricDimensions[];
}

/**
 * Metric dimension.
 */
model MetricDimensions {
  /**
   * Dimension name.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Dimension display name.
   */
  @visibility(Lifecycle.Read)
  displayName?: string;
}

/**
 * The log metric specification for exposing performance metrics to shoebox.
 */
model LogSpecifications {
  /**
   * The name of metric.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * The displayed name of log.
   */
  @visibility(Lifecycle.Read)
  displayName?: string;

  /**
   * The blob duration for the log.
   */
  @visibility(Lifecycle.Read)
  blobDuration?: string;
}

/**
 * The status of operation.
 */
model OperationStatus {
  /**
   * The operation Id.
   */
  id?: string;

  /**
   * The operation name.
   */
  name?: string;

  /**
   * The start time of the operation.
   */
  startTime?: string;

  /**
   * The end time of the operation.
   */
  endTime?: string;

  /**
   * The status of the operation.
   */
  status?: string;

  /**
   * The error detail of the operation if any.
   */
  error?: ErrorDetail;
}
