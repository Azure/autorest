# Microsoft.Network template schema

Creates a Microsoft.Network resource.

## Schema format

To create a Microsoft.Network, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Network/trafficmanagerprofiles",
  "apiVersion": "2015-11-01",
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
## Values

The following tables describe the values you need to set in the schema.

<a id="trafficmanagerprofiles" />
## trafficmanagerprofiles object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/trafficmanagerprofiles**<br /> |
|  apiVersion | Yes | enum<br />**2015-11-01**<br /> |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[ProfileProperties object](#ProfileProperties)<br /> |


<a id="ProfileProperties" />
## ProfileProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  profileStatus | No | string<br /><br />Gets or sets the status of the Traffic Manager profile.  Possible values are 'Enabled' and 'Disabled'. |
|  trafficRoutingMethod | No | string<br /><br />Gets or sets the traffic routing method of the Traffic Manager profile.  Possible values are 'Performance', 'Weighted', or 'Priority'. |
|  dnsConfig | No | object<br />[DnsConfig object](#DnsConfig)<br /><br />Gets or sets the DNS settings of the Traffic Manager profile. |
|  monitorConfig | No | object<br />[MonitorConfig object](#MonitorConfig)<br /><br />Gets or sets the endpoint monitoring settings of the Traffic Manager profile. |
|  endpoints | No | array<br />[Endpoint object](#Endpoint)<br /><br />Gets or sets the list of endpoints in the Traffic Manager profile. |


<a id="DnsConfig" />
## DnsConfig object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  relativeName | No | string<br /><br />Gets or sets the relative DNS name provided by this Traffic Manager profile.  This value is combined with the DNS domain name used by Azure Traffic Manager to form the fully-qualified domain name (FQDN) of the profile. |
|  fqdn | No | string<br /><br />Gets or sets the fully-qualified domain name (FQDN) of the Traffic Manager profile.  This is formed from the concatenation of the RelativeName with the DNS domain used by Azure Traffic Manager. |
|  ttl | No | integer<br /><br />Gets or sets the DNS Ttime-To-Live (TTL), in seconds.  This informs the local DNS resolvers and DNS clients how long to cache DNS responses provided by this Traffic Manager profile. |


<a id="MonitorConfig" />
## MonitorConfig object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  profileMonitorStatus | No | string<br /><br />Gets or sets the profile-level monitoring status of the Traffic Manager profile. |
|  protocol | No | string<br /><br />Gets or sets the protocol (HTTP or HTTPS) used to probe for endpoint health. |
|  port | No | integer<br /><br />Gets or sets the TCP port used to probe for endpoint health. |
|  path | No | string<br /><br />Gets or sets the path relative to the endpoint domain name used to probe for endpoint health. |


<a id="Endpoint" />
## Endpoint object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Gets or sets the ID of the Traffic Manager endpoint. |
|  name | No | string<br /><br />Gets or sets the name of the Traffic Manager endpoint. |
|  type | No | string<br /><br />Gets or sets the endpoint type of the Traffic Manager endpoint. |
|  properties | No | object<br />[EndpointProperties object](#EndpointProperties)<br /> |


<a id="EndpointProperties" />
## EndpointProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  targetResourceId | No | string<br /><br />Gets or sets the Azure Resource URI of the of the endpoint.  Not applicable to endpoints of type 'ExternalEndpoints'. |
|  target | No | string<br /><br />Gets or sets the fully-qualified DNS name of the endpoint.  Traffic Manager returns this value in DNS responses to direct traffic to this endpoint. |
|  endpointStatus | No | string<br /><br />Gets or sets the status of the endpoint..  If the endpoint is Enabled, it is probed for endpoint health and is included in the traffic routing method.  Possible values are 'Enabled' and 'Disabled'. |
|  weight | No | integer<br /><br />Gets or sets the weight of this endpoint when using the 'Weighted' traffic routing method. Possible values are from 1 to 1000. |
|  priority | No | integer<br /><br />Gets or sets the priority of this endpoint when using the ‘Priority’ traffic routing method. Possible values are from 1 to 1000, lower values represent higher priority. This is an optional parameter.  If specified, it must be specified on all endpoints, and no two endpoints can share the same priority value. |
|  endpointLocation | No | string<br /><br />Specifies the location of the external or nested endpoints when using the ‘Performance’ traffic routing method. |
|  endpointMonitorStatus | No | string<br /><br />Gets or sets the monitoring status of the endpoint. |
|  minChildEndpoints | No | integer<br /><br />Gets or sets the minimum number of endpoints that must be available in the child profile in order for the parent profile to be considered available. Only applicable to endpoint of type 'NestedEndpoints'. |

