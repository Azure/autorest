# Microsoft.Network/applicationGateways template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.Network/applicationGateways resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Network/applicationGateways",
  "apiVersion": "2016-03-30",
  "id": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "sku": {
      "name": "string",
      "tier": "Standard",
      "capacity": "integer"
    },
    "gatewayIPConfigurations": [
      {
        "id": "string",
        "properties": {
          "subnet": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "sslCertificates": [
      {
        "id": "string",
        "properties": {
          "data": "string",
          "password": "string",
          "publicCertData": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "frontendIPConfigurations": [
      {
        "id": "string",
        "properties": {
          "privateIPAddress": "string",
          "privateIPAllocationMethod": "string",
          "subnet": {
            "id": "string"
          },
          "publicIPAddress": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "frontendPorts": [
      {
        "id": "string",
        "properties": {
          "port": "integer",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "probes": [
      {
        "id": "string",
        "properties": {
          "protocol": "string",
          "host": "string",
          "path": "string",
          "interval": "integer",
          "timeout": "integer",
          "unhealthyThreshold": "integer",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "backendAddressPools": [
      {
        "id": "string",
        "properties": {
          "backendIPConfigurations": [
            {
              "id": "string",
              "properties": {
                "applicationGatewayBackendAddressPools": [
                  "ApplicationGatewayBackendAddressPool"
                ],
                "loadBalancerBackendAddressPools": [
                  {
                    "id": "string",
                    "properties": {
                      "backendIPConfigurations": [
                        "NetworkInterfaceIPConfiguration"
                      ],
                      "loadBalancingRules": [
                        {
                          "id": "string"
                        }
                      ],
                      "outboundNatRule": {
                        "id": "string"
                      },
                      "provisioningState": "string"
                    },
                    "name": "string",
                    "etag": "string"
                  }
                ],
                "loadBalancerInboundNatRules": [
                  {
                    "id": "string",
                    "properties": {
                      "frontendIPConfiguration": {
                        "id": "string"
                      },
                      "backendIPConfiguration": "NetworkInterfaceIPConfiguration",
                      "protocol": "string",
                      "frontendPort": "integer",
                      "backendPort": "integer",
                      "idleTimeoutInMinutes": "integer",
                      "enableFloatingIP": boolean,
                      "provisioningState": "string"
                    },
                    "name": "string",
                    "etag": "string"
                  }
                ],
                "privateIPAddress": "string",
                "privateIPAllocationMethod": "string",
                "privateIPAddressVersion": "string",
                "subnet": {
                  "id": "string",
                  "properties": {
                    "addressPrefix": "string",
                    "networkSecurityGroup": {
                      "id": "string",
                      "location": "string",
                      "tags": {},
                      "properties": {
                        "securityRules": [
                          {
                            "id": "string",
                            "properties": {
                              "description": "string",
                              "protocol": "string",
                              "sourcePortRange": "string",
                              "destinationPortRange": "string",
                              "sourceAddressPrefix": "string",
                              "destinationAddressPrefix": "string",
                              "access": "string",
                              "priority": "integer",
                              "direction": "string",
                              "provisioningState": "string"
                            },
                            "name": "string",
                            "etag": "string"
                          }
                        ],
                        "defaultSecurityRules": [
                          {
                            "id": "string",
                            "properties": {
                              "description": "string",
                              "protocol": "string",
                              "sourcePortRange": "string",
                              "destinationPortRange": "string",
                              "sourceAddressPrefix": "string",
                              "destinationAddressPrefix": "string",
                              "access": "string",
                              "priority": "integer",
                              "direction": "string",
                              "provisioningState": "string"
                            },
                            "name": "string",
                            "etag": "string"
                          }
                        ],
                        "networkInterfaces": [
                          {
                            "id": "string",
                            "location": "string",
                            "tags": {},
                            "properties": {
                              "virtualMachine": {
                                "id": "string"
                              },
                              "networkSecurityGroup": "NetworkSecurityGroup",
                              "ipConfigurations": [
                                "NetworkInterfaceIPConfiguration"
                              ],
                              "dnsSettings": {
                                "dnsServers": [
                                  "string"
                                ],
                                "appliedDnsServers": [
                                  "string"
                                ],
                                "internalDnsNameLabel": "string",
                                "internalFqdn": "string",
                                "internalDomainNameSuffix": "string"
                              },
                              "macAddress": "string",
                              "primary": boolean,
                              "enableIPForwarding": boolean,
                              "resourceGuid": "string",
                              "provisioningState": "string"
                            },
                            "etag": "string"
                          }
                        ],
                        "subnets": [
                          "Subnet"
                        ],
                        "resourceGuid": "string",
                        "provisioningState": "string"
                      },
                      "etag": "string"
                    },
                    "routeTable": {
                      "id": "string",
                      "location": "string",
                      "tags": {},
                      "properties": {
                        "routes": [
                          {
                            "id": "string",
                            "properties": {
                              "addressPrefix": "string",
                              "nextHopType": "string",
                              "nextHopIpAddress": "string",
                              "provisioningState": "string"
                            },
                            "name": "string",
                            "etag": "string"
                          }
                        ],
                        "subnets": [
                          "Subnet"
                        ],
                        "provisioningState": "string"
                      },
                      "etag": "string"
                    },
                    "ipConfigurations": [
                      {
                        "id": "string",
                        "properties": {
                          "privateIPAddress": "string",
                          "privateIPAllocationMethod": "string",
                          "subnet": "Subnet",
                          "publicIPAddress": {
                            "id": "string",
                            "location": "string",
                            "tags": {},
                            "properties": {
                              "publicIPAllocationMethod": "string",
                              "publicIPAddressVersion": "string",
                              "ipConfiguration": "IPConfiguration",
                              "dnsSettings": {
                                "domainNameLabel": "string",
                                "fqdn": "string",
                                "reverseFqdn": "string"
                              },
                              "ipAddress": "string",
                              "idleTimeoutInMinutes": "integer",
                              "resourceGuid": "string",
                              "provisioningState": "string"
                            },
                            "etag": "string"
                          },
                          "provisioningState": "string"
                        },
                        "name": "string",
                        "etag": "string"
                      }
                    ],
                    "provisioningState": "string"
                  },
                  "name": "string",
                  "etag": "string"
                },
                "publicIPAddress": {
                  "id": "string",
                  "location": "string",
                  "tags": {},
                  "properties": {
                    "publicIPAllocationMethod": "string",
                    "publicIPAddressVersion": "string",
                    "ipConfiguration": {
                      "id": "string",
                      "properties": {
                        "privateIPAddress": "string",
                        "privateIPAllocationMethod": "string",
                        "subnet": {
                          "id": "string",
                          "properties": {
                            "addressPrefix": "string",
                            "networkSecurityGroup": {
                              "id": "string",
                              "location": "string",
                              "tags": {},
                              "properties": {
                                "securityRules": [
                                  {
                                    "id": "string",
                                    "properties": {
                                      "description": "string",
                                      "protocol": "string",
                                      "sourcePortRange": "string",
                                      "destinationPortRange": "string",
                                      "sourceAddressPrefix": "string",
                                      "destinationAddressPrefix": "string",
                                      "access": "string",
                                      "priority": "integer",
                                      "direction": "string",
                                      "provisioningState": "string"
                                    },
                                    "name": "string",
                                    "etag": "string"
                                  }
                                ],
                                "defaultSecurityRules": [
                                  {
                                    "id": "string",
                                    "properties": {
                                      "description": "string",
                                      "protocol": "string",
                                      "sourcePortRange": "string",
                                      "destinationPortRange": "string",
                                      "sourceAddressPrefix": "string",
                                      "destinationAddressPrefix": "string",
                                      "access": "string",
                                      "priority": "integer",
                                      "direction": "string",
                                      "provisioningState": "string"
                                    },
                                    "name": "string",
                                    "etag": "string"
                                  }
                                ],
                                "networkInterfaces": [
                                  {
                                    "id": "string",
                                    "location": "string",
                                    "tags": {},
                                    "properties": {
                                      "virtualMachine": {
                                        "id": "string"
                                      },
                                      "networkSecurityGroup": "NetworkSecurityGroup",
                                      "ipConfigurations": [
                                        "NetworkInterfaceIPConfiguration"
                                      ],
                                      "dnsSettings": {
                                        "dnsServers": [
                                          "string"
                                        ],
                                        "appliedDnsServers": [
                                          "string"
                                        ],
                                        "internalDnsNameLabel": "string",
                                        "internalFqdn": "string",
                                        "internalDomainNameSuffix": "string"
                                      },
                                      "macAddress": "string",
                                      "primary": boolean,
                                      "enableIPForwarding": boolean,
                                      "resourceGuid": "string",
                                      "provisioningState": "string"
                                    },
                                    "etag": "string"
                                  }
                                ],
                                "subnets": [
                                  "Subnet"
                                ],
                                "resourceGuid": "string",
                                "provisioningState": "string"
                              },
                              "etag": "string"
                            },
                            "routeTable": {
                              "id": "string",
                              "location": "string",
                              "tags": {},
                              "properties": {
                                "routes": [
                                  {
                                    "id": "string",
                                    "properties": {
                                      "addressPrefix": "string",
                                      "nextHopType": "string",
                                      "nextHopIpAddress": "string",
                                      "provisioningState": "string"
                                    },
                                    "name": "string",
                                    "etag": "string"
                                  }
                                ],
                                "subnets": [
                                  "Subnet"
                                ],
                                "provisioningState": "string"
                              },
                              "etag": "string"
                            },
                            "ipConfigurations": [
                              "IPConfiguration"
                            ],
                            "provisioningState": "string"
                          },
                          "name": "string",
                          "etag": "string"
                        },
                        "publicIPAddress": "PublicIPAddress",
                        "provisioningState": "string"
                      },
                      "name": "string",
                      "etag": "string"
                    },
                    "dnsSettings": {
                      "domainNameLabel": "string",
                      "fqdn": "string",
                      "reverseFqdn": "string"
                    },
                    "ipAddress": "string",
                    "idleTimeoutInMinutes": "integer",
                    "resourceGuid": "string",
                    "provisioningState": "string"
                  },
                  "etag": "string"
                },
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ],
          "backendAddresses": [
            {
              "fqdn": "string",
              "ipAddress": "string"
            }
          ],
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "backendHttpSettingsCollection": [
      {
        "id": "string",
        "properties": {
          "port": "integer",
          "protocol": "string",
          "cookieBasedAffinity": "string",
          "requestTimeout": "integer",
          "probe": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "httpListeners": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "frontendPort": {
            "id": "string"
          },
          "protocol": "string",
          "hostName": "string",
          "sslCertificate": {
            "id": "string"
          },
          "requireServerNameIndication": boolean,
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "urlPathMaps": [
      {
        "id": "string",
        "properties": {
          "defaultBackendAddressPool": {
            "id": "string"
          },
          "defaultBackendHttpSettings": {
            "id": "string"
          },
          "pathRules": [
            {
              "id": "string",
              "properties": {
                "paths": [
                  "string"
                ],
                "backendAddressPool": {
                  "id": "string"
                },
                "backendHttpSettings": {
                  "id": "string"
                },
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ],
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "requestRoutingRules": [
      {
        "id": "string",
        "properties": {
          "ruleType": "string",
          "backendAddressPool": {
            "id": "string"
          },
          "backendHttpSettings": {
            "id": "string"
          },
          "httpListener": {
            "id": "string"
          },
          "urlPathMap": {
            "id": "string"
          },
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "resourceGuid": "string",
    "provisioningState": "string"
  },
  "etag": "string"
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Network/applicationGateways" />
### Microsoft.Network/applicationGateways object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Network/applicationGateways |
|  apiVersion | enum | Yes | 2016-03-30 |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [ApplicationGatewayPropertiesFormat object](#ApplicationGatewayPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayPropertiesFormat" />
### ApplicationGatewayPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  sku | object | No | Gets or sets sku of application gateway resource - [ApplicationGatewaySku object](#ApplicationGatewaySku) |
|  gatewayIPConfigurations | array | No | Gets or sets subnets of application gateway resource - [ApplicationGatewayIPConfiguration object](#ApplicationGatewayIPConfiguration) |
|  sslCertificates | array | No | Gets or sets ssl certificates of application gateway resource - [ApplicationGatewaySslCertificate object](#ApplicationGatewaySslCertificate) |
|  frontendIPConfigurations | array | No | Gets or sets frontend IP addresses of application gateway resource - [ApplicationGatewayFrontendIPConfiguration object](#ApplicationGatewayFrontendIPConfiguration) |
|  frontendPorts | array | No | Gets or sets frontend ports of application gateway resource - [ApplicationGatewayFrontendPort object](#ApplicationGatewayFrontendPort) |
|  probes | array | No | Gets or sets probes of application gateway resource - [ApplicationGatewayProbe object](#ApplicationGatewayProbe) |
|  backendAddressPools | array | No | Gets or sets backend address pool of application gateway resource - [ApplicationGatewayBackendAddressPool object](#ApplicationGatewayBackendAddressPool) |
|  backendHttpSettingsCollection | array | No | Gets or sets backend http settings of application gateway resource - [ApplicationGatewayBackendHttpSettings object](#ApplicationGatewayBackendHttpSettings) |
|  httpListeners | array | No | Gets or sets HTTP listeners of application gateway resource - [ApplicationGatewayHttpListener object](#ApplicationGatewayHttpListener) |
|  urlPathMaps | array | No | Gets or sets URL path map of application gateway resource - [ApplicationGatewayUrlPathMap object](#ApplicationGatewayUrlPathMap) |
|  requestRoutingRules | array | No | Gets or sets request routing rules of application gateway resource - [ApplicationGatewayRequestRoutingRule object](#ApplicationGatewayRequestRoutingRule) |
|  resourceGuid | string | No | Gets or sets resource guid property of the ApplicationGateway resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the ApplicationGateway resource Updating/Deleting/Failed |


<a id="ApplicationGatewaySku" />
### ApplicationGatewaySku object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | enum | No | Gets or sets name of application gateway SKU. - Standard_Small, Standard_Medium, Standard_Large |
|  tier | enum | No | Gets or sets tier of application gateway. - Standard |
|  capacity | integer | No | Gets or sets capacity (instance count) of application gateway |


<a id="ApplicationGatewayIPConfiguration" />
### ApplicationGatewayIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayIPConfigurationPropertiesFormat object](#ApplicationGatewayIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewaySslCertificate" />
### ApplicationGatewaySslCertificate object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewaySslCertificatePropertiesFormat object](#ApplicationGatewaySslCertificatePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayFrontendIPConfiguration" />
### ApplicationGatewayFrontendIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayFrontendIPConfigurationPropertiesFormat object](#ApplicationGatewayFrontendIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayFrontendPort" />
### ApplicationGatewayFrontendPort object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayFrontendPortPropertiesFormat object](#ApplicationGatewayFrontendPortPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayProbe" />
### ApplicationGatewayProbe object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayProbePropertiesFormat object](#ApplicationGatewayProbePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendAddressPool" />
### ApplicationGatewayBackendAddressPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayBackendAddressPoolPropertiesFormat object](#ApplicationGatewayBackendAddressPoolPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendHttpSettings" />
### ApplicationGatewayBackendHttpSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayBackendHttpSettingsPropertiesFormat object](#ApplicationGatewayBackendHttpSettingsPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayHttpListener" />
### ApplicationGatewayHttpListener object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayHttpListenerPropertiesFormat object](#ApplicationGatewayHttpListenerPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayUrlPathMap" />
### ApplicationGatewayUrlPathMap object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayUrlPathMapPropertiesFormat object](#ApplicationGatewayUrlPathMapPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayRequestRoutingRule" />
### ApplicationGatewayRequestRoutingRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayRequestRoutingRulePropertiesFormat object](#ApplicationGatewayRequestRoutingRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayIPConfigurationPropertiesFormat" />
### ApplicationGatewayIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  subnet | object | No | Gets or sets the reference of the subnet resource.A subnet from where appliation gateway gets its private address  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the application gateway subnet resource Updating/Deleting/Failed |


<a id="ApplicationGatewaySslCertificatePropertiesFormat" />
### ApplicationGatewaySslCertificatePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  data | string | No | Gets or sets the certificate data  |
|  password | string | No | Gets or sets the certificate password  |
|  publicCertData | string | No | Gets or sets the certificate public data  |
|  provisioningState | string | No | Gets or sets Provisioning state of the ssl certificate resource Updating/Deleting/Failed |


<a id="ApplicationGatewayFrontendIPConfigurationPropertiesFormat" />
### ApplicationGatewayFrontendIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the Network Interface IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [SubResource object](#SubResource) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ApplicationGatewayFrontendPortPropertiesFormat" />
### ApplicationGatewayFrontendPortPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  port | integer | No | Gets or sets the frontend port |
|  provisioningState | string | No | Gets or sets Provisioning state of the frontend port resource Updating/Deleting/Failed |


<a id="ApplicationGatewayProbePropertiesFormat" />
### ApplicationGatewayProbePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  protocol | enum | No | Gets or sets the protocol. - Http or Https |
|  host | string | No | Gets or sets the host to send probe to  |
|  path | string | No | Gets or sets the relative path of probe  |
|  interval | integer | No | Gets or sets probing interval in seconds  |
|  timeout | integer | No | Gets or sets probing timeout in seconds  |
|  unhealthyThreshold | integer | No | Gets or sets probing unhealthy threshold  |
|  provisioningState | string | No | Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayBackendAddressPoolPropertiesFormat" />
### ApplicationGatewayBackendAddressPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  backendIPConfigurations | array | No | Gets collection of references to IPs defined in NICs - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  backendAddresses | array | No | Gets or sets the backend addresses - [ApplicationGatewayBackendAddress object](#ApplicationGatewayBackendAddress) |
|  provisioningState | string | No | Gets or sets Provisioning state of the backend address pool resource Updating/Deleting/Failed |


<a id="ApplicationGatewayBackendHttpSettingsPropertiesFormat" />
### ApplicationGatewayBackendHttpSettingsPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  port | integer | No | Gets or sets the port |
|  protocol | enum | No | Gets or sets the protocol. - Http or Https |
|  cookieBasedAffinity | enum | No | Gets or sets the cookie affinity. - Enabled or Disabled |
|  requestTimeout | integer | No | Gets or sets request timeout |
|  probe | object | No | Gets or sets probe resource of application gateway  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayHttpListenerPropertiesFormat" />
### ApplicationGatewayHttpListenerPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets frontend IP configuration resource of application gateway  - [SubResource object](#SubResource) |
|  frontendPort | object | No | Gets or sets frontend port resource of application gateway  - [SubResource object](#SubResource) |
|  protocol | enum | No | Gets or sets the protocol. - Http or Https |
|  hostName | string | No | Gets or sets the host name of http listener  |
|  sslCertificate | object | No | Gets or sets ssl certificate resource of application gateway  - [SubResource object](#SubResource) |
|  requireServerNameIndication | boolean | No | Gets or sets the requireServerNameIndication of http listener  |
|  provisioningState | string | No | Gets or sets Provisioning state of the http listener resource Updating/Deleting/Failed |


<a id="ApplicationGatewayUrlPathMapPropertiesFormat" />
### ApplicationGatewayUrlPathMapPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  defaultBackendAddressPool | object | No | Gets or sets default backend address pool resource of URL path map  - [SubResource object](#SubResource) |
|  defaultBackendHttpSettings | object | No | Gets or sets default backend http settings resource of URL path map  - [SubResource object](#SubResource) |
|  pathRules | array | No | Gets or sets path rule of URL path map resource - [ApplicationGatewayPathRule object](#ApplicationGatewayPathRule) |
|  provisioningState | string | No | Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayRequestRoutingRulePropertiesFormat" />
### ApplicationGatewayRequestRoutingRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ruleType | enum | No | Gets or sets the rule type. - Basic or PathBasedRouting |
|  backendAddressPool | object | No | Gets or sets backend address pool resource of application gateway  - [SubResource object](#SubResource) |
|  backendHttpSettings | object | No | Gets or sets frontend port resource of application gateway  - [SubResource object](#SubResource) |
|  httpListener | object | No | Gets or sets http listener resource of application gateway  - [SubResource object](#SubResource) |
|  urlPathMap | object | No | Gets or sets url path map resource of application gateway  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets Provisioning state of the request routing rule resource Updating/Deleting/Failed |


<a id="SubResource" />
### SubResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |


<a id="NetworkInterfaceIPConfiguration" />
### NetworkInterfaceIPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [NetworkInterfaceIPConfigurationPropertiesFormat object](#NetworkInterfaceIPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendAddress" />
### ApplicationGatewayBackendAddress object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  fqdn | string | No | Gets or sets the dns name |
|  ipAddress | string | No | Gets or sets the ip address |


<a id="ApplicationGatewayPathRule" />
### ApplicationGatewayPathRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [ApplicationGatewayPathRulePropertiesFormat object](#ApplicationGatewayPathRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterfaceIPConfigurationPropertiesFormat" />
### NetworkInterfaceIPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  applicationGatewayBackendAddressPools | array | No | Gets or sets the reference of ApplicationGatewayBackendAddressPool resource - [ApplicationGatewayBackendAddressPool object](#ApplicationGatewayBackendAddressPool) |
|  loadBalancerBackendAddressPools | array | No | Gets or sets the reference of LoadBalancerBackendAddressPool resource - [BackendAddressPool object](#BackendAddressPool) |
|  loadBalancerInboundNatRules | array | No | Gets or sets list of references of LoadBalancerInboundNatRules - [InboundNatRule object](#InboundNatRule) |
|  privateIPAddress | string | No |  |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  privateIPAddressVersion | enum | No | Gets or sets PrivateIP address version (IPv4/IPv6). - IPv4 or IPv6 |
|  subnet | object | No | [Subnet object](#Subnet) |
|  publicIPAddress | object | No | [PublicIPAddress object](#PublicIPAddress) |
|  provisioningState | string | No |  |


<a id="ApplicationGatewayPathRulePropertiesFormat" />
### ApplicationGatewayPathRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  paths | array | No | Gets or sets the path rules of URL path map - string |
|  backendAddressPool | object | No | Gets or sets backend address pool resource of URL path map  - [SubResource object](#SubResource) |
|  backendHttpSettings | object | No | Gets or sets backend http settings resource of URL path map  - [SubResource object](#SubResource) |
|  provisioningState | string | No | Gets or sets path rule of URL path map resource Updating/Deleting/Failed |


<a id="BackendAddressPool" />
### BackendAddressPool object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [BackendAddressPoolPropertiesFormat object](#BackendAddressPoolPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="InboundNatRule" />
### InboundNatRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [InboundNatRulePropertiesFormat object](#InboundNatRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="Subnet" />
### Subnet object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SubnetPropertiesFormat object](#SubnetPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="PublicIPAddress" />
### PublicIPAddress object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [PublicIPAddressPropertiesFormat object](#PublicIPAddressPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="BackendAddressPoolPropertiesFormat" />
### BackendAddressPoolPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  backendIPConfigurations | array | No | Gets collection of references to IPs defined in NICs - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  loadBalancingRules | array | No | Gets Load Balancing rules that use this Backend Address Pool - [SubResource object](#SubResource) |
|  outboundNatRule | object | No | Gets outbound rules that use this Backend Address Pool - [SubResource object](#SubResource) |
|  provisioningState | string | No | Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatRulePropertiesFormat" />
### InboundNatRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  frontendIPConfiguration | object | No | Gets or sets a reference to frontend IP Addresses - [SubResource object](#SubResource) |
|  backendIPConfiguration | object | No | Gets or sets a reference to a private ip address defined on a NetworkInterface of a VM. Traffic sent to frontendPort of each of the frontendIPConfigurations is forwarded to the backed IP - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  protocol | enum | No | Gets or sets the transport potocol for the external endpoint. Possible values are Udp or Tcp. - Udp or Tcp |
|  frontendPort | integer | No | Gets or sets the port for the external endpoint. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | integer | No | Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | integer | No | Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This emlement is only used when the protocol is set to Tcp |
|  enableFloatingIP | boolean | No | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SubnetPropertiesFormat" />
### SubnetPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets Address prefix for the subnet. |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [NetworkSecurityGroup object](#NetworkSecurityGroup) |
|  routeTable | object | No | Gets or sets the reference of the RouteTable resource - [RouteTable object](#RouteTable) |
|  ipConfigurations | array | No | Gets array of references to the network interface IP configurations using subnet - [IPConfiguration object](#IPConfiguration) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="PublicIPAddressPropertiesFormat" />
### PublicIPAddressPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publicIPAllocationMethod | enum | No | Gets or sets PublicIP allocation method (Static/Dynamic). - Static or Dynamic |
|  publicIPAddressVersion | enum | No | Gets or sets PublicIP address version (IPv4/IPv6). - IPv4 or IPv6 |
|  ipConfiguration | object | No | [IPConfiguration object](#IPConfiguration) |
|  dnsSettings | object | No | Gets or sets FQDN of the DNS record associated with the public IP address - [PublicIPAddressDnsSettings object](#PublicIPAddressDnsSettings) |
|  ipAddress | string | No |  |
|  idleTimeoutInMinutes | integer | No | Gets or sets the Idletimeout of the public IP address |
|  resourceGuid | string | No | Gets or sets resource guid property of the PublicIP resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="NetworkSecurityGroup" />
### NetworkSecurityGroup object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [NetworkSecurityGroupPropertiesFormat object](#NetworkSecurityGroupPropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="RouteTable" />
### RouteTable object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [RouteTablePropertiesFormat object](#RouteTablePropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="IPConfiguration" />
### IPConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [IPConfigurationPropertiesFormat object](#IPConfigurationPropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="PublicIPAddressDnsSettings" />
### PublicIPAddressDnsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  domainNameLabel | string | No | Gets or sets the Domain name label.The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
|  fqdn | string | No | Gets the FQDN, Fully qualified domain name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
|  reverseFqdn | string | No | Gets or Sests the Reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.  |


<a id="NetworkSecurityGroupPropertiesFormat" />
### NetworkSecurityGroupPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  securityRules | array | No | Gets or sets Security rules of network security group - [SecurityRule object](#SecurityRule) |
|  defaultSecurityRules | array | No | Gets or sets Default security rules of network security group - [SecurityRule object](#SecurityRule) |
|  networkInterfaces | array | No | Gets collection of references to Network Interfaces - [NetworkInterface object](#NetworkInterface) |
|  subnets | array | No | Gets collection of references to subnets - [Subnet object](#Subnet) |
|  resourceGuid | string | No | Gets or sets resource guid property of the network security group resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="RouteTablePropertiesFormat" />
### RouteTablePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  routes | array | No | Gets or sets Routes in a Route Table - [Route object](#Route) |
|  subnets | array | No | Gets collection of references to subnets - [Subnet object](#Subnet) |
|  provisioningState | string | No | Gets or sets Provisioning state of the resource Updating/Deleting/Failed |


<a id="IPConfigurationPropertiesFormat" />
### IPConfigurationPropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  privateIPAddress | string | No | Gets or sets the privateIPAddress of the IP Configuration |
|  privateIPAllocationMethod | enum | No | Gets or sets PrivateIP allocation method (Static/Dynamic). - Static or Dynamic |
|  subnet | object | No | Gets or sets the reference of the subnet resource - [Subnet object](#Subnet) |
|  publicIPAddress | object | No | Gets or sets the reference of the PublicIP resource - [PublicIPAddress object](#PublicIPAddress) |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SecurityRule" />
### SecurityRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterface" />
### NetworkInterface object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  location | string | No | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | No | [NetworkInterfacePropertiesFormat object](#NetworkInterfacePropertiesFormat) |
|  etag | string | No | Gets a unique read-only string that changes whenever the resource is updated |


<a id="Route" />
### Route object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  properties | object | No | [RoutePropertiesFormat object](#RoutePropertiesFormat) |
|  name | string | No | Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | string | No | A unique read-only string that changes whenever the resource is updated |


<a id="SecurityRulePropertiesFormat" />
### SecurityRulePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  description | string | No | Gets or sets a description for this rule. Restricted to 140 chars. |
|  protocol | enum | Yes | Gets or sets Network protocol this rule applies to. Can be Tcp, Udp or All(*). - Tcp, Udp, * |
|  sourcePortRange | string | No | Gets or sets Source Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  destinationPortRange | string | No | Gets or sets Destination Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  sourceAddressPrefix | string | Yes | Gets or sets source address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from.  |
|  destinationAddressPrefix | string | Yes | Gets or sets destination address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.  |
|  access | enum | Yes | Gets or sets network traffic is allowed or denied. Possible values are 'Allow' and 'Deny'. - Allow or Deny |
|  priority | integer | No | Gets or sets the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
|  direction | enum | Yes | Gets or sets the direction of the rule.InBound or Outbound. The direction specifies if rule will be evaluated on incoming or outcoming traffic. - Inbound or Outbound |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="NetworkInterfacePropertiesFormat" />
### NetworkInterfacePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualMachine | object | No | Gets or sets the reference of a VirtualMachine - [SubResource object](#SubResource) |
|  networkSecurityGroup | object | No | Gets or sets the reference of the NetworkSecurityGroup resource - [NetworkSecurityGroup object](#NetworkSecurityGroup) |
|  ipConfigurations | array | No | Gets or sets list of IPConfigurations of the NetworkInterface - [NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration) |
|  dnsSettings | object | No | Gets or sets DNS Settings in  NetworkInterface - [NetworkInterfaceDnsSettings object](#NetworkInterfaceDnsSettings) |
|  macAddress | string | No | Gets the MAC Address of the network interface |
|  primary | boolean | No | Gets whether this is a primary NIC on a virtual machine |
|  enableIPForwarding | boolean | No | Gets or sets whether IPForwarding is enabled on the NIC |
|  resourceGuid | string | No | Gets or sets resource guid property of the network interface resource |
|  provisioningState | string | No | Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="RoutePropertiesFormat" />
### RoutePropertiesFormat object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressPrefix | string | No | Gets or sets the destination CIDR to which the route applies. |
|  nextHopType | enum | Yes | Gets or sets the type of Azure hop the packet should be sent to. - VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, None |
|  nextHopIpAddress | string | No | Gets or sets the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |
|  provisioningState | string | No | Gets or sets Provisioning state of the resource Updating/Deleting/Failed |


<a id="NetworkInterfaceDnsSettings" />
### NetworkInterfaceDnsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  dnsServers | array | No | Gets or sets list of DNS servers IP addresses - string |
|  appliedDnsServers | array | No | Gets or sets list of Applied DNS servers IP addresses - string |
|  internalDnsNameLabel | string | No | Gets or sets the Internal DNS name |
|  internalFqdn | string | No | Gets or sets the internal fqdn. |
|  internalDomainNameSuffix | string | No | Gets or sets internal domain name suffix of the NIC. |

