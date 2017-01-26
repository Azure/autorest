# Microsoft.Network/trafficmanagerprofiles template reference
API Version: 2015-11-01
## Template format

To create a Microsoft.Network/trafficmanagerprofiles resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.Network/trafficmanagerprofiles",
  "apiVersion": "2015-11-01",
  "location": "string",
  "tags": {},
  "properties": {
    "profileStatus": "string",
    "trafficRoutingMethod": "string",
    "dnsConfig": {
      "relativeName": "string",
      "fqdn": "string",
      "ttl": "integer"
    },
    "monitorConfig": {
      "profileMonitorStatus": "string",
      "protocol": "string",
      "port": "integer",
      "path": "string"
    },
    "endpoints": [
      {
        "id": "string",
        "name": "string",
        "type": "string",
        "properties": {
          "targetResourceId": "string",
          "target": "string",
          "endpointStatus": "string",
          "weight": "integer",
          "priority": "integer",
          "endpointLocation": "string",
          "endpointMonitorStatus": "string",
          "minChildEndpoints": "integer"
        }
      }
    ]
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/trafficmanagerprofiles" />
### Microsoft.Network/trafficmanagerprofiles object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.Network/trafficmanagerprofiles |
|  apiVersion | enum | Yes | 2015-11-01 |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [ProfileProperties object](#ProfileProperties) |


<a id="ProfileProperties" />
### ProfileProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  profileStatus | string | No | Gets or sets the status of the Traffic Manager profile.  Possible values are 'Enabled' and 'Disabled'. |
|  trafficRoutingMethod | string | No | Gets or sets the traffic routing method of the Traffic Manager profile.  Possible values are 'Performance', 'Weighted', or 'Priority'. |
|  dnsConfig | object | No | Gets or sets the DNS settings of the Traffic Manager profile. - [DnsConfig object](#DnsConfig) |
|  monitorConfig | object | No | Gets or sets the endpoint monitoring settings of the Traffic Manager profile. - [MonitorConfig object](#MonitorConfig) |
|  endpoints | array | No | Gets or sets the list of endpoints in the Traffic Manager profile. - [Endpoint object](#Endpoint) |


<a id="DnsConfig" />
### DnsConfig object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  relativeName | string | No | Gets or sets the relative DNS name provided by this Traffic Manager profile.  This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile. |
|  fqdn | string | No | Gets or sets the fully-qualified domain name (FQDN) of the Traffic Manager profile.  This is formed from the concatenation of the RelativeName with the DNS domain used by Azure Traffic Manager. |
|  ttl | integer | No | Gets or sets the DNS Ttime-To-Live (TTL), in seconds.  This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile. |


<a id="MonitorConfig" />
### MonitorConfig object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  profileMonitorStatus | string | No | Gets or sets the profile-level monitoring status of the Traffic Manager profile. |
|  protocol | string | No | Gets or sets the protocol (HTTP or HTTPS) used to probe for endpoint health. |
|  port | integer | No | Gets or sets the TCP port used to probe for endpoint health. |
|  path | string | No | Gets or sets the path relative to the endpoint domain name used to probe for endpoint health. |


<a id="Endpoint" />
### Endpoint object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Gets or sets the ID of the Traffic Manager endpoint. |
|  name | string | No | Gets or sets the name of the Traffic Manager endpoint. |
|  type | string | No | Gets or sets the endpoint type of the Traffic Manager endpoint. |
|  properties | object | No | [EndpointProperties object](#EndpointProperties) |


<a id="EndpointProperties" />
### EndpointProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  targetResourceId | string | No | Gets or sets the Azure Resource URI of the of the endpoint.  Not applicable to endpoints of type 'ExternalEndpoints'. |
|  target | string | No | Gets or sets the fully-qualified DNS name of the endpoint.  Traffic Manager returns this value in DNS responses to direct traffic to this endpoint. |
|  endpointStatus | string | No | Gets or sets the status of the endpoint..  If the endpoint is Enabled, it is probed for endpoint health and is included in the traffic routing method.  Possible values are 'Enabled' and 'Disabled'. |
|  weight | integer | No | Gets or sets the weight of this endpoint when using the 'Weighted' traffic routing method. Possible values are from 1 to 1000. |
|  priority | integer | No | Gets or sets the priority of this endpoint when using the ‘Priority’ traffic routing method. Possible values are from 1 to 1000, lower values represent higher priority. This is an optional parameter.  If specified, it must be specified on all endpoints, and no two endpoints can share the same priority value. |
|  endpointLocation | string | No | Specifies the location of the external or nested endpoints when using the ‘Performance’ traffic routing method. |
|  endpointMonitorStatus | string | No | Gets or sets the monitoring status of the endpoint. |
|  minChildEndpoints | integer | No | Gets or sets the minimum number of endpoints that must be available in the child profile in order for the parent profile to be considered available. Only applicable to endpoint of type 'NestedEndpoints'. |

