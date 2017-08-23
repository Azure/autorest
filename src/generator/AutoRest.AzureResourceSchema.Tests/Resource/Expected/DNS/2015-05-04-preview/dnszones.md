# Microsoft.Network/dnszones template reference
API Version: 2015-05-04-preview
## Template format

To create a Microsoft.Network/dnszones resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/dnszones",
  "apiVersion": "2015-05-04-preview",
  "location": "string",
  "tags": {},
  "etag": "string",
  "properties": {
    "maxNumberOfRecordSets": "integer",
    "numberOfRecordSets": "integer"
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/dnszones" />
### Microsoft.Network/dnszones object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/dnszones |
|  apiVersion | enum | Yes | 2015-05-04-preview |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  etag | string | No | Gets or sets the ETag of the zone that is being updated, as received from a Get operation. |
|  properties | object | Yes | Gets or sets the properties of the zone. - [ZoneProperties object](#ZoneProperties) |
|  resources | array | No | [TXT](./dnszones/TXT.md) [SRV](./dnszones/SRV.md) [SOA](./dnszones/SOA.md) [PTR](./dnszones/PTR.md) [NS](./dnszones/NS.md) [MX](./dnszones/MX.md) [CNAME](./dnszones/CNAME.md) [AAAA](./dnszones/AAAA.md) [A](./dnszones/A.md) |


<a id="ZoneProperties" />
### ZoneProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  maxNumberOfRecordSets | integer | No | Gets or sets the maximum number of record sets that can be created in this zone. |
|  numberOfRecordSets | integer | No | Gets or sets the current number of record sets in this zone. |

