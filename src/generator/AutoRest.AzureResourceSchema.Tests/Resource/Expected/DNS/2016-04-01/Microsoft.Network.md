# Microsoft.Network template schema

Creates a Microsoft.Network resource.

## Schema format

To create a Microsoft.Network, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Network/dnszones/A",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/AAAA",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/CNAME",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/MX",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/NS",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/PTR",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/SOA",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/SRV",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones/TXT",
  "apiVersion": "2016-04-01",
  "properties": {
    "metadata": {},
    "TTL": "integer",
    "ARecords": [
      {
        "ipv4Address": "string"
      }
    ],
    "AAAARecords": [
      {
        "ipv6Address": "string"
      }
    ],
    "MXRecords": [
      {
        "preference": "integer",
        "exchange": "string"
      }
    ],
    "NSRecords": [
      {
        "nsdname": "string"
      }
    ],
    "PTRRecords": [
      {
        "ptrdname": "string"
      }
    ],
    "SRVRecords": [
      {
        "priority": "integer",
        "weight": "integer",
        "port": "integer",
        "target": "string"
      }
    ],
    "TXTRecords": [
      {
        "value": [
          "string"
        ]
      }
    ],
    "CNAMERecord": {
      "cname": "string"
    },
    "SOARecord": {
      "host": "string",
      "email": "string",
      "serialNumber": "integer",
      "refreshTime": "integer",
      "retryTime": "integer",
      "expireTime": "integer",
      "minimumTTL": "integer"
    }
  }
}
```
```
{
  "type": "Microsoft.Network/dnszones",
  "apiVersion": "2016-04-01",
  "location": "string",
  "properties": {
    "maxNumberOfRecordSets": "integer",
    "numberOfRecordSets": "integer"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="dnszones_A" />
## dnszones_A object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/A**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_AAAA" />
## dnszones_AAAA object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/AAAA**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_CNAME" />
## dnszones_CNAME object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/CNAME**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_MX" />
## dnszones_MX object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/MX**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_NS" />
## dnszones_NS object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/NS**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_PTR" />
## dnszones_PTR object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/PTR**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_SOA" />
## dnszones_SOA object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/SOA**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_SRV" />
## dnszones_SRV object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/SRV**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_TXT" />
## dnszones_TXT object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones/TXT**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones" />
## dnszones object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/dnszones**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  etag | No | string<br /><br />Gets or sets the ETag of the zone that is being updated, as received from a Get operation. |
|  properties | Yes | object<br />[ZoneProperties object](#ZoneProperties)<br /><br />Gets or sets the properties of the zone. |
|  resources | No | array<br />[TXT object](#TXT)<br />[SRV object](#SRV)<br />[SOA object](#SOA)<br />[PTR object](#PTR)<br />[NS object](#NS)<br />[MX object](#MX)<br />[CNAME object](#CNAME)<br />[AAAA object](#AAAA)<br />[A object](#A)<br /> |


<a id="RecordSetProperties" />
## RecordSetProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  metadata | No | object<br /><br />Gets or sets the metadata attached to the resource. |
|  TTL | No | integer<br /><br />Gets or sets the TTL of the records in the RecordSet. |
|  ARecords | No | array<br />[ARecord object](#ARecord)<br /><br />Gets or sets the list of A records in the RecordSet. |
|  AAAARecords | No | array<br />[AaaaRecord object](#AaaaRecord)<br /><br />Gets or sets the list of AAAA records in the RecordSet. |
|  MXRecords | No | array<br />[MxRecord object](#MxRecord)<br /><br />Gets or sets the list of MX records in the RecordSet. |
|  NSRecords | No | array<br />[NsRecord object](#NsRecord)<br /><br />Gets or sets the list of NS records in the RecordSet. |
|  PTRRecords | No | array<br />[PtrRecord object](#PtrRecord)<br /><br />Gets or sets the list of PTR records in the RecordSet. |
|  SRVRecords | No | array<br />[SrvRecord object](#SrvRecord)<br /><br />Gets or sets the list of SRV records in the RecordSet. |
|  TXTRecords | No | array<br />[TxtRecord object](#TxtRecord)<br /><br />Gets or sets the list of TXT records in the RecordSet. |
|  CNAMERecord | No | object<br />[CnameRecord object](#CnameRecord)<br /><br />Gets or sets the CNAME record in the RecordSet. |
|  SOARecord | No | object<br />[SoaRecord object](#SoaRecord)<br /><br />Gets or sets the SOA record in the RecordSet. |


<a id="ARecord" />
## ARecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  ipv4Address | No | string<br /><br />Gets or sets the IPv4 address of this A record in string notation. |


<a id="AaaaRecord" />
## AaaaRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  ipv6Address | No | string<br /><br />Gets or sets the IPv6 address of this AAAA record in string notation. |


<a id="MxRecord" />
## MxRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  preference | No | integer<br /><br />Gets or sets the preference metric for this record. |
|  exchange | No | string<br /><br />Gets or sets the domain name of the mail host, without a terminating dot. |


<a id="NsRecord" />
## NsRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  nsdname | No | string<br /><br />Gets or sets the name server name for this record, without a terminating dot. |


<a id="PtrRecord" />
## PtrRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  ptrdname | No | string<br /><br />Gets or sets the PTR target domain name for this record without a terminating dot. |


<a id="SrvRecord" />
## SrvRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  priority | No | integer<br /><br />Gets or sets the priority metric for this record. |
|  weight | No | integer<br /><br />Gets or sets the weight metric for this this record. |
|  port | No | integer<br /><br />Gets or sets the port of the service for this record. |
|  target | No | string<br /><br />Gets or sets the domain name of the target for this record, without a terminating dot. |


<a id="TxtRecord" />
## TxtRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  value | No | array<br />**string**<br /><br />Gets or sets the text value of this record. |


<a id="CnameRecord" />
## CnameRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  cname | No | string<br /><br />Gets or sets the canonical name for this record without a terminating dot. |


<a id="SoaRecord" />
## SoaRecord object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  host | No | string<br /><br />Gets or sets the domain name of the authoritative name server, without a temrinating dot. |
|  email | No | string<br /><br />Gets or sets the email for this record. |
|  serialNumber | No | integer<br /><br />Gets or sets the serial number for this record. |
|  refreshTime | No | integer<br /><br />Gets or sets the refresh value for this record. |
|  retryTime | No | integer<br /><br />Gets or sets the retry time for this record. |
|  expireTime | No | integer<br /><br />Gets or sets the expire time for this record. |
|  minimumTTL | No | integer<br /><br />Gets or sets the minimum TTL value for this record. |


<a id="ZoneProperties" />
## ZoneProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  maxNumberOfRecordSets | No | integer<br /><br />Gets or sets the maximum number of record sets that can be created in this zone. |
|  numberOfRecordSets | No | integer<br /><br />Gets or sets the current number of record sets in this zone. |


<a id="dnszones_TXT_childResource" />
## dnszones_TXT_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**TXT**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_SRV_childResource" />
## dnszones_SRV_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**SRV**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_SOA_childResource" />
## dnszones_SOA_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**SOA**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_PTR_childResource" />
## dnszones_PTR_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**PTR**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_NS_childResource" />
## dnszones_NS_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**NS**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_MX_childResource" />
## dnszones_MX_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**MX**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_CNAME_childResource" />
## dnszones_CNAME_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**CNAME**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_AAAA_childResource" />
## dnszones_AAAA_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**AAAA**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |


<a id="dnszones_A_childResource" />
## dnszones_A_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**A**<br /> |
|  apiVersion | Yes | enum<br />**2016-04-01**<br /> |
|  id | No | string<br /><br />Gets or sets the ID of the resource. |
|  name | No | string<br /><br />Gets or sets the name of the resource. |
|  etag | No | string<br /><br />Gets or sets the ETag of the RecordSet. |
|  location | No | string<br /><br />Gets or sets the location of the resource. |
|  properties | Yes | object<br />[RecordSetProperties object](#RecordSetProperties)<br /><br />Gets or sets the properties of the RecordSet. |

