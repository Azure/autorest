import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DnsZone.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Dns;
/**
 * Describes a DNS record set (a collection of DNS records with the same name and type).
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(DnsZone)
@includeInapplicableMetadataInPayload(false)
model DnsRecord {
  ...ResourceNameParameter<
    Resource = DnsRecord,
    KeyName = "relativeRecordSetName",
    SegmentName = "A",
    NamePattern = ""
  >;

  /**
   * The ID of the record set.
   */
  @visibility("read")
  id?: string;

  /**
   * The type of the record set.
   */
  @visibility("read")
  type?: string;

  /**
   * The etag of the record set.
   */
  etag?: string;

  /**
   * The properties of the record set.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RecordSetProperties;
}

@armResourceOperations
interface DnsRecords {
  /**
   * Gets a record set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RecordSets_Get")
  get is ArmResourceRead<
    DnsRecord,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsRecord>;

      /**
       * The type of DNS record in this record set.
       */
      @path
      recordType: RecordType;
    }
  >;

  /**
   * Creates or updates a record set within a DNS zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RecordSets_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DnsRecord,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsRecord>;

      /**
       * The type of DNS record in this record set. Record sets of type SOA can be updated but not created (they are created when the DNS zone is created).
       */
      @path
      recordType: RecordType;

      /**
       * The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting any concurrent changes.
       */
      @header
      IfMatch?: string;

      /**
       * Set to '*' to allow a new record set to be created, but to prevent updating an existing record set. Other values will be ignored.
       */
      @header
      IfNoneMatch?: string;
    }
  >;

  /**
   * Updates a record set within a DNS zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("RecordSets_Update")
  update is ArmCustomPatchSync<
    DnsRecord,
    DnsRecord,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsRecord>;

      /**
       * The type of DNS record in this record set.
       */
      @path
      recordType: RecordType;

      /**
       * The etag of the record set. Omit this value to always overwrite the current record set. Specify the last-seen etag value to prevent accidentally overwriting concurrent changes.
       */
      @header
      IfMatch?: string;
    }
  >;

  /**
   * Deletes a record set from a DNS zone. This operation cannot be undone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RecordSets_Delete")
  delete is ArmResourceDeleteSync<
    DnsRecord,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsRecord>;

      /**
       * The type of DNS record in this record set. Record sets of type SOA cannot be deleted (they are deleted when the DNS zone is deleted).
       */
      @path
      recordType: RecordType;

      /**
       * The etag of the record set. Omit this value to always delete the current record set. Specify the last-seen etag value to prevent accidentally deleting any concurrent changes.
       */
      @header
      IfMatch?: string;
    }
  >;

  /**
   * Lists the record sets of a specified type in a DNS zone.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RecordSets_ListByType")
  listByType is ArmResourceListByParent<
    DnsRecord,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DnsRecord>;

      /**
       * The type of record sets to enumerate.
       */
      @path
      recordType: RecordType;

      /**
       * The maximum number of record sets to return. If not specified, returns up to 100 record sets.
       */
      @query("$top")
      $top?: int32;

      /**
       * The suffix label of the record set name that has to be used to filter the record set enumerations. If this parameter is specified, Enumeration will return only records that end with .<recordSetNameSuffix>
       */
      @query("$recordsetnamesuffix")
      $recordsetnamesuffix?: string;
    }
  >;
}

@@doc(DnsRecord.name,
  "The name of the record set, relative to the name of the zone."
);
@@encodedName(DnsRecords.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(DnsRecords.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(DnsRecords.createOrUpdate::parameters.resource,
  "Parameters supplied to the CreateOrUpdate operation."
);
@@encodedName(DnsRecords.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(DnsRecords.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(DnsRecords.update::parameters.properties,
  "Parameters supplied to the Update operation."
);
