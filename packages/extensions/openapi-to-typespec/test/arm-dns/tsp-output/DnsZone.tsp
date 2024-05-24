import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Dns;
/**
 * Describes a DNS zone.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model DnsZone extends Resource {
  ...ResourceNameParameter<
    Resource = DnsZone,
    KeyName = "zoneName",
    SegmentName = "dnsZones",
    NamePattern = ""
  >;

  /**
   * The etag of the zone.
   */
  etag?: string;

  /**
   * The properties of the zone.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ZoneProperties;
}

@armResourceOperations
interface DnsZones {
  /**
   * Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Zones_Get")
  get is ArmResourceRead<DnsZone>;

  /**
   * Creates or updates a DNS zone. Does not modify DNS records within the zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Zones_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DnsZone,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsZone>;

      /**
       * The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
       */
      @header
      IfMatch?: string;

      /**
       * Set to '*' to allow a new DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.
       */
      @header
      IfNoneMatch?: string;
    }
  >;

  /**
   * Updates a DNS zone. Does not modify DNS records within the zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Zones_Update")
  update is ArmCustomPatchSync<
    DnsZone,
    ZoneUpdateOptions,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsZone>;

      /**
       * The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
       */
      @header
      IfMatch?: string;
    }
  >;

  /**
   * Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Zones_Delete")
  delete is ArmResourceDeleteAsync<
    DnsZone,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsZone>;

      /**
       * The etag of the DNS zone. Omit this value to always delete the current zone. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
       */
      @header
      IfMatch?: string;
    }
  >;

  /**
   * Lists the DNS zones within a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Zones_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DnsZone,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsZone>;

      /**
       * The maximum number of record sets to return. If not specified, returns up to 100 record sets.
       */
      @query("$top")
      $top?: int32;
    }
  >;

  /**
   * Lists the DNS zones in all resource groups in a subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Zones_List")
  list is ArmListBySubscription<DnsZone>;

  /**
   * Lists all record sets in a DNS zone.
   */
  // FIXME: RecordSets_ListByDnsZone could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RecordSets_ListByDnsZone")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/recordsets")
  @get
  listByDnsZone(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the DNS zone (without a terminating dot).
     */
    @path
    zoneName: string,

    /**
     * The maximum number of record sets to return. If not specified, returns up to 100 record sets.
     */
    @query("$top")
    $top?: int32,

    /**
     * The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
     */
    @query("$recordsetnamesuffix")
    $recordsetnamesuffix?: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<ResourceListResult<DnsRecord>> | ErrorResponse;
}

@@doc(DnsZone.name, "The name of the DNS zone (without a terminating dot).");
@@encodedName(DnsZones.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(DnsZones.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(DnsZones.createOrUpdate::parameters.resource,
  "Parameters supplied to the CreateOrUpdate operation."
);
@@encodedName(DnsZones.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(DnsZones.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(DnsZones.update::parameters.properties,
  "Parameters supplied to the Update operation."
);
