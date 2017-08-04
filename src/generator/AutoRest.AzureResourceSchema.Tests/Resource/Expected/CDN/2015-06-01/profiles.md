# Microsoft.Cdn/profiles template reference
API Version: 2015-06-01
## Template format

To create a Microsoft.Cdn/profiles resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Cdn/profiles",
  "apiVersion": "2015-06-01",
  "location": "string",
  "tags": {},
  "properties": {
    "sku": {
      "name": "string"
    }
  },
  "resources": []
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Cdn/profiles" />
### Microsoft.Cdn/profiles object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Cdn/profiles |
|  apiVersion | enum | Yes | 2015-06-01 |
|  location | string | Yes | Profile location |
|  tags | object | No | Profile tags |
|  properties | object | Yes | [ProfilePropertiesCreateParameters object](#ProfilePropertiesCreateParameters) |
|  resources | array | No | [endpoints](./profiles/endpoints.md) |


<a id="ProfilePropertiesCreateParameters" />
### ProfilePropertiesCreateParameters object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sku | object | Yes | Profile SKU - [Sku object](#Sku) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Name of the pricing tier. - Standard or Premium |

