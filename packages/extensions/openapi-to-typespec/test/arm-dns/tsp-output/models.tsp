import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.Dns;

interface Operations extends Azure.ResourceManager.Operations {}

@fixed
enum RecordType {
  A,
  AAAA,
  CAA,
  CNAME,
  MX,
  NS,
  PTR,
  SOA,
  SRV,
  TXT,
}

/**
 * The type of this DNS zone (Public or Private).
 */
@fixed
enum DnsZoneType {
  Public,
  Private,
}

/**
 * Represents the properties of the records in the record set.
 */
model RecordSetProperties {
  /**
   * The metadata attached to the record set.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  metadata?: Record<string>;

  /**
   * The TTL (time-to-live) of the records in the record set.
   */
  @encodedName("application/json", "TTL")
  ttlInSeconds?: int64;

  /**
   * Fully qualified domain name of the record set.
   */
  @visibility("read")
  fqdn?: string;

  /**
   * provisioning State of the record set.
   */
  @visibility("read")
  provisioningState?: string;

  /**
   * A reference to an azure resource from where the dns resource value is taken.
   */
  targetResource?: SubResource;

  /**
   * The list of A records in the record set.
   */
  @encodedName("application/json", "ARecords")
  aRecords?: ARecord[];

  /**
   * The list of AAAA records in the record set.
   */
  @encodedName("application/json", "AAAARecords")
  aaaaRecords?: AaaaRecord[];

  /**
   * The list of MX records in the record set.
   */
  MXRecords?: MxRecord[];

  /**
   * The list of NS records in the record set.
   */
  NSRecords?: NsRecord[];

  /**
   * The list of PTR records in the record set.
   */
  @encodedName("application/json", "PTRRecords")
  ptrRecords?: PtrRecord[];

  /**
   * The list of SRV records in the record set.
   */
  @encodedName("application/json", "SRVRecords")
  srvRecords?: SrvRecord[];

  /**
   * The list of TXT records in the record set.
   */
  @encodedName("application/json", "TXTRecords")
  txtRecords?: TxtRecord[];

  /**
   * The CNAME record in the  record set.
   */
  @encodedName("application/json", "CNAMERecord")
  cnameRecord?: CnameRecord;

  /**
   * The SOA record in the record set.
   */
  @encodedName("application/json", "SOARecord")
  soaRecord?: SoaRecord;

  /**
   * The list of CAA records in the record set.
   */
  caaRecords?: CaaRecord[];
}

/**
 * A reference to a another resource
 */
model SubResource {
  /**
   * Resource Id.
   */
  id?: string;
}

/**
 * An A record.
 */
model ARecord {
  /**
   * The IPv4 address of this A record.
   */
  ipv4Address?: string;
}

/**
 * An AAAA record.
 */
model AaaaRecord {
  /**
   * The IPv6 address of this AAAA record.
   */
  ipv6Address?: string;
}

/**
 * An MX record.
 */
model MxRecord {
  /**
   * The preference value for this MX record.
   */
  preference?: int32;

  /**
   * The domain name of the mail host for this MX record.
   */
  exchange?: string;
}

/**
 * An NS record.
 */
model NsRecord {
  /**
   * The name server name for this NS record.
   */
  @encodedName("application/json", "nsdname")
  dnsNSDomainName?: string;
}

/**
 * A PTR record.
 */
model PtrRecord {
  /**
   * The PTR target domain name for this PTR record.
   */
  @encodedName("application/json", "ptrdname")
  dnsPtrDomainName?: string;
}

/**
 * An SRV record.
 */
model SrvRecord {
  /**
   * The priority value for this SRV record.
   */
  priority?: int32;

  /**
   * The weight value for this SRV record.
   */
  weight?: int32;

  /**
   * The port value for this SRV record.
   */
  port?: int32;

  /**
   * The target domain name for this SRV record.
   */
  target?: string;
}

/**
 * A TXT record.
 */
model TxtRecord {
  /**
   * The text value of this TXT record.
   */
  @encodedName("application/json", "value")
  values?: string[];
}

/**
 * A CNAME record.
 */
model CnameRecord {
  /**
   * The canonical name for this CNAME record.
   */
  cname?: string;
}

/**
 * An SOA record.
 */
model SoaRecord {
  /**
   * The domain name of the authoritative name server for this SOA record.
   */
  host?: string;

  /**
   * The email contact for this SOA record.
   */
  email?: string;

  /**
   * The serial number for this SOA record.
   */
  serialNumber?: int64;

  /**
   * The refresh value for this SOA record.
   */
  @encodedName("application/json", "refreshTime")
  refreshTimeInSeconds?: int64;

  /**
   * The retry time for this SOA record.
   */
  @encodedName("application/json", "retryTime")
  retryTimeInSeconds?: int64;

  /**
   * The expire time for this SOA record.
   */
  @encodedName("application/json", "expireTime")
  expireTimeInSeconds?: int64;

  /**
   * The minimum value for this SOA record. By convention this is used to determine the negative caching duration.
   */
  @encodedName("application/json", "minimumTTL")
  minimumTtlInSeconds?: int64;
}

/**
 * A CAA record.
 */
model CaaRecord {
  /**
   * The flags for this CAA record as an integer between 0 and 255.
   */
  flags?: int32;

  /**
   * The tag for this CAA record.
   */
  tag?: string;

  /**
   * The value for this CAA record.
   */
  value?: string;
}

/**
 * An error response from the service.
 */
@error
model CloudError {
  /**
   * Cloud error body.
   */
  error?: CloudErrorBody;
}

/**
 * An error response from the service.
 */
model CloudErrorBody {
  /**
   * An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
   */
  code?: string;

  /**
   * A message describing the error, intended to be suitable for display in a user interface.
   */
  message?: string;

  /**
   * The target of the particular error. For example, the name of the property in error.
   */
  target?: string;

  /**
   * A list of additional details about the error.
   */
  details?: CloudErrorBody[];
}

/**
 * Represents the properties of the zone.
 */
model ZoneProperties {
  /**
   * The maximum number of record sets that can be created in this DNS zone.  This is a read-only property and any attempt to set this value will be ignored.
   */
  @visibility("read")
  @encodedName("application/json", "maxNumberOfRecordSets")
  maxNumberOfRecords?: int64;

  /**
   * The maximum number of records per record set that can be created in this DNS zone.  This is a read-only property and any attempt to set this value will be ignored.
   */
  @visibility("read")
  @encodedName("application/json", "maxNumberOfRecordsPerRecordSet")
  maxNumberOfRecordsPerRecord?: int64;

  /**
   * The current number of record sets in this DNS zone.  This is a read-only property and any attempt to set this value will be ignored.
   */
  @visibility("read")
  @encodedName("application/json", "numberOfRecordSets")
  numberOfRecords?: int64;

  /**
   * The name servers for this DNS zone. This is a read-only property and any attempt to set this value will be ignored.
   */
  @visibility("read")
  nameServers?: string[];

  /**
   * The type of this DNS zone (Public or Private).
   */
  zoneType?: DnsZoneType = DnsZoneType.Public;

  /**
   * A list of references to virtual networks that register hostnames in this DNS zone. This is a only when ZoneType is Private.
   */
  registrationVirtualNetworks?: SubResource[];

  /**
   * A list of references to virtual networks that resolve records in this DNS zone. This is a only when ZoneType is Private.
   */
  resolutionVirtualNetworks?: SubResource[];
}

/**
 * Common properties of an Azure Resource Manager resource
 */
model Resource {
  /**
   * Resource ID.
   */
  @visibility("read")
  id?: string;

  /**
   * Resource name.
   */
  @visibility("read")
  name?: string;

  /**
   * Resource type.
   */
  @visibility("read")
  type?: string;

  /**
   * Resource location.
   */
  @visibility("read", "create")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  location: string;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Describes a request to update a DNS zone.
 */
model ZoneUpdateOptions {
  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Represents the properties of the Dns Resource Reference Request.
 */
model DnsResourceReferenceRequest {
  /**
   * The properties of the Resource Reference Request.
   */
  properties?: DnsResourceReferenceRequestProperties;
}

/**
 * Represents the properties of the Dns Resource Reference Request.
 */
model DnsResourceReferenceRequestProperties {
  /**
   * A list of references to azure resources for which referencing dns records need to be queried.
   */
  targetResources?: SubResource[];
}

/**
 * Represents the properties of the Dns Resource Reference Result.
 */
model DnsResourceReferenceResult {
  /**
   * The result of dns resource reference request. Returns a list of dns resource references for each of the azure resource in the request.
   */
  properties?: DnsResourceReferenceResultProperties;
}

/**
 * The result of dns resource reference request. Returns a list of dns resource references for each of the azure resource in the request.
 */
model DnsResourceReferenceResultProperties {
  /**
   * The result of dns resource reference request. A list of dns resource references for each of the azure resource in the request
   */
  dnsResourceReferences?: DnsResourceReference[];
}

/**
 * Represents a single Azure resource and its referencing DNS records.
 */
model DnsResourceReference {
  /**
   * A list of dns Records
   */
  dnsResources?: SubResource[];

  /**
   * A reference to an azure resource from where the dns resource value is taken.
   */
  targetResource?: SubResource;
}

/**
 * Parameters supplied to update a record set.
 */
model RecordSetUpdateParameters {
  /**
   * Specifies information about the record set being updated.
   */
  @encodedName("application/json", "RecordSet")
  recordSet?: DnsRecord;
}
