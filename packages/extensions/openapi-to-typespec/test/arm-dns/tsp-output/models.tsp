import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Dns;

interface Operations extends Azure.ResourceManager.Operations {}

@Azure.Core.fixed
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
@Azure.Core.fixed
enum DnsZoneType {
  Public,
  Private,
}

@doc("Represents the properties of the records in the record set.")
model RecordSetProperties {
  @doc("The metadata attached to the record set.")
  metadata?: Record<string>;

  @doc("The TTL (time-to-live) of the records in the record set.")
  @projectedName("json", "TTL")
  ttlInSeconds?: int32;

  @doc("Fully qualified domain name of the record set.")
  @visibility("read")
  fqdn?: string;

  @doc("provisioning State of the record set.")
  @visibility("read")
  provisioningState?: string;

  @doc("A reference to an azure resource from where the dns resource value is taken.")
  targetResource?: SubResource;

  @doc("The list of A records in the record set.")
  @projectedName("json", "ARecords")
  aRecords?: ARecord[];

  @doc("The list of AAAA records in the record set.")
  @projectedName("json", "AAAARecords")
  aaaaRecords?: AaaaRecord[];

  @doc("The list of MX records in the record set.")
  MXRecords?: MxRecord[];

  @doc("The list of NS records in the record set.")
  NSRecords?: NsRecord[];

  @doc("The list of PTR records in the record set.")
  @projectedName("json", "PTRRecords")
  ptrRecords?: PtrRecord[];

  @doc("The list of SRV records in the record set.")
  @projectedName("json", "SRVRecords")
  srvRecords?: SrvRecord[];

  @doc("The list of TXT records in the record set.")
  @projectedName("json", "TXTRecords")
  txtRecords?: TxtRecord[];

  @doc("The CNAME record in the  record set.")
  @projectedName("json", "CNAMERecord")
  cnameRecord?: CnameRecord;

  @doc("The SOA record in the record set.")
  @projectedName("json", "SOARecord")
  soaRecord?: SoaRecord;

  @doc("The list of CAA records in the record set.")
  caaRecords?: CaaRecord[];
}

@doc("A reference to a another resource")
model SubResource {
  @doc("Resource Id.")
  id?: string;
}

@doc("An A record.")
model ARecord {
  @doc("The IPv4 address of this A record.")
  ipv4Address?: string;
}

@doc("An AAAA record.")
model AaaaRecord {
  @doc("The IPv6 address of this AAAA record.")
  ipv6Address?: string;
}

@doc("An MX record.")
model MxRecord {
  @doc("The preference value for this MX record.")
  preference?: int32;

  @doc("The domain name of the mail host for this MX record.")
  exchange?: string;
}

@doc("An NS record.")
model NsRecord {
  @doc("The name server name for this NS record.")
  @projectedName("json", "nsdname")
  dnsNSDomainName?: string;
}

@doc("A PTR record.")
model PtrRecord {
  @doc("The PTR target domain name for this PTR record.")
  @projectedName("json", "ptrdname")
  dnsPtrDomainName?: string;
}

@doc("An SRV record.")
model SrvRecord {
  @doc("The priority value for this SRV record.")
  priority?: int32;

  @doc("The weight value for this SRV record.")
  weight?: int32;

  @doc("The port value for this SRV record.")
  port?: int32;

  @doc("The target domain name for this SRV record.")
  target?: string;
}

@doc("A TXT record.")
model TxtRecord {
  @doc("The text value of this TXT record.")
  @projectedName("json", "value")
  values?: string[];
}

@doc("A CNAME record.")
model CnameRecord {
  @doc("The canonical name for this CNAME record.")
  cname?: string;
}

@doc("An SOA record.")
model SoaRecord {
  @doc("The domain name of the authoritative name server for this SOA record.")
  host?: string;

  @doc("The email contact for this SOA record.")
  email?: string;

  @doc("The serial number for this SOA record.")
  serialNumber?: int32;

  @doc("The refresh value for this SOA record.")
  @projectedName("json", "refreshTime")
  refreshTimeInSeconds?: int32;

  @doc("The retry time for this SOA record.")
  @projectedName("json", "retryTime")
  retryTimeInSeconds?: int32;

  @doc("The expire time for this SOA record.")
  @projectedName("json", "expireTime")
  expireTimeInSeconds?: int32;

  @doc("The minimum value for this SOA record. By convention this is used to determine the negative caching duration.")
  @projectedName("json", "minimumTTL")
  minimumTtlInSeconds?: int32;
}

@doc("A CAA record.")
model CaaRecord {
  @doc("The flags for this CAA record as an integer between 0 and 255.")
  flags?: int32;

  @doc("The tag for this CAA record.")
  tag?: string;

  @doc("The value for this CAA record.")
  value?: string;
}

@doc("An error response from the service.")
@error
model CloudError {
  @doc("Cloud error body.")
  error?: CloudErrorBody;
}

@doc("An error response from the service.")
model CloudErrorBody {
  @doc("An identifier for the error. Codes are invariant and are intended to be consumed programmatically.")
  code?: string;

  @doc("A message describing the error, intended to be suitable for display in a user interface.")
  message?: string;

  @doc("The target of the particular error. For example, the name of the property in error.")
  target?: string;

  @doc("A list of additional details about the error.")
  details?: CloudErrorBody[];
}

@doc("Represents the properties of the zone.")
model ZoneProperties {
  @doc("The maximum number of record sets that can be created in this DNS zone.  This is a read-only property and any attempt to set this value will be ignored.")
  @visibility("read")
  @projectedName("json", "maxNumberOfRecordSets")
  maxNumberOfRecords?: int32;

  @doc("The maximum number of records per record set that can be created in this DNS zone.  This is a read-only property and any attempt to set this value will be ignored.")
  @visibility("read")
  @projectedName("json", "maxNumberOfRecordsPerRecordSet")
  maxNumberOfRecordsPerRecord?: int32;

  @doc("The current number of record sets in this DNS zone.  This is a read-only property and any attempt to set this value will be ignored.")
  @visibility("read")
  @projectedName("json", "numberOfRecordSets")
  numberOfRecords?: int32;

  @doc("The name servers for this DNS zone. This is a read-only property and any attempt to set this value will be ignored.")
  @visibility("read")
  nameServers?: string[];

  @doc("The type of this DNS zone (Public or Private).")
  zoneType?: DnsZoneType;

  @doc("A list of references to virtual networks that register hostnames in this DNS zone. This is a only when ZoneType is Private.")
  registrationVirtualNetworks?: SubResource[];

  @doc("A list of references to virtual networks that resolve records in this DNS zone. This is a only when ZoneType is Private.")
  resolutionVirtualNetworks?: SubResource[];
}

@doc("Common properties of an Azure Resource Manager resource")
model Resource {
  @doc("Resource ID.")
  @visibility("read")
  id?: string;

  @doc("Resource name.")
  @visibility("read")
  name?: string;

  @doc("Resource type.")
  @visibility("read")
  type?: string;

  @doc("Resource location.")
  @visibility("read", "create")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  location: string;

  @doc("Resource tags.")
  tags?: Record<string>;
}

@doc("Represents the properties of the Dns Resource Reference Request.")
model DnsResourceReferenceRequest {
  @doc("The properties of the Resource Reference Request.")
  properties?: DnsResourceReferenceRequestProperties;
}

@doc("Represents the properties of the Dns Resource Reference Request.")
model DnsResourceReferenceRequestProperties {
  @doc("A list of references to azure resources for which referencing dns records need to be queried.")
  targetResources?: SubResource[];
}

@doc("Represents the properties of the Dns Resource Reference Result.")
model DnsResourceReferenceResult {
  @doc("The result of dns resource reference request. Returns a list of dns resource references for each of the azure resource in the request.")
  properties?: DnsResourceReferenceResultProperties;
}

@doc("The result of dns resource reference request. Returns a list of dns resource references for each of the azure resource in the request.")
model DnsResourceReferenceResultProperties {
  @doc("The result of dns resource reference request. A list of dns resource references for each of the azure resource in the request")
  dnsResourceReferences?: DnsResourceReference[];
}

@doc("Represents a single Azure resource and its referencing DNS records.")
model DnsResourceReference {
  @doc("A list of dns Records ")
  dnsResources?: SubResource[];

  @doc("A reference to an azure resource from where the dns resource value is taken.")
  targetResource?: SubResource;
}

@doc("Parameters supplied to update a record set.")
model RecordSetUpdateParameters {
  @doc("Specifies information about the record set being updated.")
  @projectedName("json", "RecordSet")
  recordSet?: DnsRecord;
}
