# Microsoft.Cdn/profiles template reference
API Version: 2016-04-02
## Template format

To create a Microsoft.Cdn/profiles resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Cdn/profiles",
  "apiVersion": "2016-04-02",
  "location": "string",
  "tags": {},
  "sku": {
    "name": "string"
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
|  apiVersion | enum | Yes | 2016-04-02 |
|  location | string | Yes | Profile location |
|  tags | object | No | Profile tags |
|  sku | object | Yes | The SKU (pricing tier) of the CDN profile. - [Sku object](#Sku) |
|  resources | array | No | [endpoints](./profiles/endpoints.md) |


<a id="Sku" />
### Sku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Name of the pricing tier. - Standard_Verizon, Premium_Verizon, Custom_Verizon, Standard_Akamai |

