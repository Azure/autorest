# Microsoft.Network/dnszones template reference
API Version: 2016-04-01
## Template format

To create a Microsoft.Network/dnszones resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/dnszones",
  "apiVersion": "2016-04-01",
  "location": "string",
  "tags": {},
  "etag": "string",
  "properties": {
    "maxNumberOfRecordSets": "integer",
    "numberOfRecordSets": "integer"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/dnszones" />
### Microsoft.Network/dnszones object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Network/dnszones |
|  apiVersion | enum | Yes | 2016-04-01 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  etag | string | No | Gets or sets the ETag of the zone that is being updated, as received from a Get operation. |
|  properties | object | Yes | Gets or sets the properties of the zone. - [ZoneProperties object](#ZoneProperties) |
|  resources | array | No | [dnszones_TXT_childResource object](#dnszones_TXT_childResource) [dnszones_SRV_childResource object](#dnszones_SRV_childResource) [dnszones_SOA_childResource object](#dnszones_SOA_childResource) [dnszones_PTR_childResource object](#dnszones_PTR_childResource) [dnszones_NS_childResource object](#dnszones_NS_childResource) [dnszones_MX_childResource object](#dnszones_MX_childResource) [dnszones_CNAME_childResource object](#dnszones_CNAME_childResource) [dnszones_AAAA_childResource object](#dnszones_AAAA_childResource) [dnszones_A_childResource object](#dnszones_A_childResource) |


<a id="ZoneProperties" />
### ZoneProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  maxNumberOfRecordSets | integer | No | Gets or sets the maximum number of record sets that can be created in this zone. |
|  numberOfRecordSets | integer | No | Gets or sets the current number of record sets in this zone. |


<a id="dnszones_TXT_childResource" />
### dnszones_TXT_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | TXT |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_SRV_childResource" />
### dnszones_SRV_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | SRV |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_SOA_childResource" />
### dnszones_SOA_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | SOA |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_PTR_childResource" />
### dnszones_PTR_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | PTR |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_NS_childResource" />
### dnszones_NS_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | NS |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_MX_childResource" />
### dnszones_MX_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | MX |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_CNAME_childResource" />
### dnszones_CNAME_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | CNAME |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_AAAA_childResource" />
### dnszones_AAAA_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | AAAA |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="dnszones_A_childResource" />
### dnszones_A_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | A |
|  apiVersion | enum | Yes | 2016-04-01 |
|  id | string | No | Gets or sets the ID of the resource. |
|  name | string | No | Gets or sets the name of the resource. |
|  etag | string | No | Gets or sets the ETag of the RecordSet. |
|  location | string | No | Gets or sets the location of the resource. |
|  properties | object | Yes | Gets or sets the properties of the RecordSet. - [RecordSetProperties object](#RecordSetProperties) |


<a id="RecordSetProperties" />
### RecordSetProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  metadata | object | No | Gets or sets the metadata attached to the resource. |
|  TTL | integer | No | Gets or sets the TTL of the records in the RecordSet. |
|  ARecords | array | No | Gets or sets the list of A records in the RecordSet. - [ARecord object](#ARecord) |
|  AAAARecords | array | No | Gets or sets the list of AAAA records in the RecordSet. - [AaaaRecord object](#AaaaRecord) |
|  MXRecords | array | No | Gets or sets the list of MX records in the RecordSet. - [MxRecord object](#MxRecord) |
|  NSRecords | array | No | Gets or sets the list of NS records in the RecordSet. - [NsRecord object](#NsRecord) |
|  PTRRecords | array | No | Gets or sets the list of PTR records in the RecordSet. - [PtrRecord object](#PtrRecord) |
|  SRVRecords | array | No | Gets or sets the list of SRV records in the RecordSet. - [SrvRecord object](#SrvRecord) |
|  TXTRecords | array | No | Gets or sets the list of TXT records in the RecordSet. - [TxtRecord object](#TxtRecord) |
|  CNAMERecord | object | No | Gets or sets the CNAME record in the RecordSet. - [CnameRecord object](#CnameRecord) |
|  SOARecord | object | No | Gets or sets the SOA record in the RecordSet. - [SoaRecord object](#SoaRecord) |


<a id="ARecord" />
### ARecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ipv4Address | string | No | Gets or sets the IPv4 address of this A record in string notation. |


<a id="AaaaRecord" />
### AaaaRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ipv6Address | string | No | Gets or sets the IPv6 address of this AAAA record in string notation. |


<a id="MxRecord" />
### MxRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  preference | integer | No | Gets or sets the preference metric for this record. |
|  exchange | string | No | Gets or sets the domain name of the mail host, without a terminating dot. |


<a id="NsRecord" />
### NsRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  nsdname | string | No | Gets or sets the name server name for this record, without a terminating dot. |


<a id="PtrRecord" />
### PtrRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ptrdname | string | No | Gets or sets the PTR target domain name for this record without a terminating dot. |


<a id="SrvRecord" />
### SrvRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  priority | integer | No | Gets or sets the priority metric for this record. |
|  weight | integer | No | Gets or sets the weight metric for this this record. |
|  port | integer | No | Gets or sets the port of the service for this record. |
|  target | string | No | Gets or sets the domain name of the target for this record, without a terminating dot. |


<a id="TxtRecord" />
### TxtRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  value | array | No | Gets or sets the text value of this record. - string |


<a id="CnameRecord" />
### CnameRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  cname | string | No | Gets or sets the canonical name for this record without a terminating dot. |


<a id="SoaRecord" />
### SoaRecord object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  host | string | No | Gets or sets the domain name of the authoritative name server, without a temrinating dot. |
|  email | string | No | Gets or sets the email for this record. |
|  serialNumber | integer | No | Gets or sets the serial number for this record. |
|  refreshTime | integer | No | Gets or sets the refresh value for this record. |
|  retryTime | integer | No | Gets or sets the retry time for this record. |
|  expireTime | integer | No | Gets or sets the expire time for this record. |
|  minimumTTL | integer | No | Gets or sets the minimum TTL value for this record. |

