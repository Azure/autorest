import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DnsZone.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Dns;
@doc("Describes a DNS record set (a collection of DNS records with the same name and type).")
@parentResource(DnsZone)
model DnsRecord is ProxyResource<RecordSetProperties> {
  @doc("The name of the record set, relative to the name of the zone.")
  @path
  @key("relativeRecordSetName")
  @segment("A")
  name: string;

  @doc("The etag of the record set.")
  etag?: string;
}

@armResourceOperations
interface DnsRecords {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a record set.")
  @operationId("RecordSets_Get")
  get is ArmResourceRead<
    DnsRecord,
    {
      ...BaseParameters<DnsRecord>;

      @doc("The type of DNS record in this record set.")
      @path
      recordType: RecordType;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates a record set within a DNS zone.")
  @operationId("RecordSets_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DnsRecord,
    {
      ...BaseParameters<DnsRecord>;

      @doc("The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the DNS zone is created).")
      @path
      recordType: RecordType;

      @doc("The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.")
      @header
      IfMatch?: string;

      @doc("Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.")
      @header
      IfNoneMatch?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates a record set within a DNS zone.")
  @operationId("RecordSets_Update")
  update is ArmCustomPatchSync<
    DnsRecord,
    DnsRecord,
    {
      ...BaseParameters<DnsRecord>;

      @doc("The type of DNS record in this record set.")
      @path
      recordType: RecordType;

      @doc("The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting concurrent changes.")
      @header
      IfMatch?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes a record set from a DNS zone. This operation cannot be undone.")
  @operationId("RecordSets_Delete")
  delete is ArmResourceDeleteSync<
    DnsRecord,
    {
      ...BaseParameters<DnsRecord>;

      @doc("The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the DNS zone is deleted).")
      @path
      recordType: RecordType;

      @doc("The etag of the record set. Omit this value to always delete the current record set. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.")
      @header
      IfMatch?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists the record sets of a specified type in a DNS zone.")
  @operationId("RecordSets_ListByType")
  listByType is ArmResourceListByParent<
    DnsRecord,
    {
      ...BaseParameters<DnsRecord>;

      @doc("The type of record sets to enumerate.")
      @path
      recordType: RecordType;

      @doc("The maximum number of record sets to return. If not specified, returns up to 100 record sets.")
      @query("$top")
      $top?: int32;

      @doc("The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>")
      @query("$recordsetnamesuffix")
      $recordsetnamesuffix?: string;
    }
  >;
}
