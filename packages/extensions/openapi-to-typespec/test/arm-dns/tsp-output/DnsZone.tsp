import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Dns;
@doc("Describes a DNS zone.")
model DnsZone is TrackedResource<ZoneProperties> {
  @doc("The name of the DNS zone (without a terminating dot).")
  @path
  @key("zoneName")
  @segment("dnsZones")
  name: string;

  @doc("The etag of the zone.")
  etag?: string;
}

@armResourceOperations
interface Zones {
  @doc("Gets a DNS zone. Retrieves the zone properties, but not the record sets within the zone.")
  get is ArmResourceRead<DnsZone>;
  @doc("Creates or updates a DNS zone. Does not modify DNS records within the zone.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DnsZone,
    {
      ...BaseParameters<DnsZone>;

      @doc("The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.")
      @header
      IfMatch?: string;

      @doc("Set to '*' to allow a new DNS zone to be created, but to prevent updating an existing zone. Other values will be ignored.")
      @header
      IfNoneMatch?: string;
    }
  >;
  @doc("Updates a DNS zone. Does not modify DNS records within the zone.")
  update is ArmCustomPatchSync<
    DnsZone,
    ZoneUpdateOptions,
    {
      ...BaseParameters<DnsZone>;

      @doc("The etag of the DNS zone. Omit this value to always overwrite the current zone. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.")
      @header
      IfMatch?: string;
    }
  >;
  @doc("Deletes a DNS zone. WARNING: All DNS records in the zone will also be deleted. This operation cannot be undone.")
  delete is ArmResourceDeleteAsync<
    DnsZone,
    {
      ...BaseParameters<DnsZone>;

      @doc("The etag of the DNS zone. Omit this value to always delete the current zone. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.")
      @header
      IfMatch?: string;
    }
  >;
  @doc("Lists the DNS zones within a resource group.")
  listByResourceGroup is ArmResourceListByParent<
    DnsZone,
    {
      ...BaseParameters<DnsZone>;

      @doc("The maximum number of record sets to return. If not specified, returns up to 100 record sets.")
      @query("$top")
      $top?: int32;
    }
  >;
  @doc("Lists the DNS zones in all resource groups in a subscription.")
  list is ArmListBySubscription<DnsZone>;
}

@armResourceOperations
interface RecordSets {
  @doc("Lists all record sets in a DNS zone.")
  // FIXME: RecordSets_ListByDnsZone could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/dnsZones/{zoneName}/recordsets")
  @get
  ListByDnsZone is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the DNS zone (without a terminating dot).")
      @path
      zoneName: string;

      @doc("The maximum number of record sets to return. If not specified, returns up to 100 record sets.")
      @query("$top")
      $top?: int32;

      @doc("The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>")
      @query("$recordsetnamesuffix")
      $recordsetnamesuffix?: string;

      @doc("Specifies the Azure subscription ID, which uniquely identifies the Microsoft Azure subscription.")
      @path
      subscriptionId: string;
    },
    DnsRecordListResult
  >;
}
