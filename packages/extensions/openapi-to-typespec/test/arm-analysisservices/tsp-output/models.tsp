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

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * The current state of Analysis Services resource. The state is to indicate more states outside of resource provisioning.
 */
enum State {
  Deleting,
  Succeeded,
  Failed,
  Paused,
  Suspended,
  Provisioning,
  Updating,
  Suspending,
  Pausing,
  Resuming,
  Preparing,
  Scaling,
}

/**
 * The current deployment state of Analysis Services resource. The provisioningState is to indicate states for resource provisioning.
 */
enum ProvisioningState {
  Deleting,
  Succeeded,
  Failed,
  Paused,
  Suspended,
  Provisioning,
  Updating,
  Suspending,
  Pausing,
  Resuming,
  Preparing,
  Scaling,
}

/**
 * The name of the Azure pricing tier to which the SKU applies.
 */
enum SkuTier {
  Development,
  Basic,
  Standard,
}

/**
 * The managed mode of the server (0 = not managed, 1 = managed).
 */
enum ManagedMode {
  `0`: 0,
  `1`: 1,
}

/**
 * The server monitor mode for AS server
 */
enum ServerMonitorMode {
  `0`: 0,
  `1`: 1,
}

/**
 * How the read-write server's participation in the query pool is controlled.<br/>It can have the following values: <ul><li>readOnly - indicates that the read-write server is intended not to participate in query operations</li><li>all - indicates that the read-write server can participate in query operations</li></ul>Specifying readOnly when capacity is 1 results in error.
 */
@fixed
enum ConnectionMode {
  All,
  ReadOnly,
}

/**
 * Properties of Analysis Services resource.
 */
model AnalysisServicesServerProperties
  extends AnalysisServicesServerMutableProperties {
  /**
   * The current state of Analysis Services resource. The state is to indicate more states outside of resource provisioning.
   */
  @visibility("read")
  state?: State;

  /**
   * The current deployment state of Analysis Services resource. The provisioningState is to indicate states for resource provisioning.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * The full name of the Analysis Services resource.
   */
  @visibility("read")
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
  @visibility("read")
  gatewayObjectId?: string;

  /**
   * Uri of the DMTS cluster.
   */
  @visibility("read")
  dmtsClusterUri?: string;
}

/**
 * An array of firewall rules.
 */
model IPv4FirewallSettings {
  /**
   * An array of firewall rules.
   */
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
  @visibility("read")
  id?: string;

  /**
   * The name of the Analysis Services resource.
   */
  @visibility("read")
  name?: string;

  /**
   * The type of the Analysis Services resource.
   */
  @visibility("read")
  type?: string;

  /**
   * Location of the Analysis Services resource.
   */
  @visibility("read", "create")
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
  properties?: AnalysisServicesServerMutableProperties;
}

/**
 * An object that represents enumerating SKUs for existing resources.
 */
model SkuEnumerationForExistingResourceResult {
  /**
   * The collection of available SKUs for existing resources.
   */
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
  @visibility("read")
  metricSpecifications?: MetricSpecifications[];

  /**
   * The log specifications.
   */
  @visibility("read")
  logSpecifications?: LogSpecifications[];
}

/**
 * Available operation metric specification for exposing performance metrics to shoebox.
 */
model MetricSpecifications {
  /**
   * The name of metric.
   */
  @visibility("read")
  name?: string;

  /**
   * The displayed name of metric.
   */
  @visibility("read")
  displayName?: string;

  /**
   * The displayed description of metric.
   */
  @visibility("read")
  displayDescription?: string;

  /**
   * The unit of the metric.
   */
  @visibility("read")
  unit?: string;

  /**
   * The aggregation type of metric.
   */
  @visibility("read")
  aggregationType?: string;

  /**
   * The dimensions of metric.
   */
  @visibility("read")
  dimensions?: MetricDimensions[];
}

/**
 * Metric dimension.
 */
model MetricDimensions {
  /**
   * Dimension name.
   */
  @visibility("read")
  name?: string;

  /**
   * Dimension display name.
   */
  @visibility("read")
  displayName?: string;
}

/**
 * The log metric specification for exposing performance metrics to shoebox.
 */
model LogSpecifications {
  /**
   * The name of metric.
   */
  @visibility("read")
  name?: string;

  /**
   * The displayed name of log.
   */
  @visibility("read")
  displayName?: string;

  /**
   * The blob duration for the log.
   */
  @visibility("read")
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
