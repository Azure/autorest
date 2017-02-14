# Microsoft.Network template schema

Creates a Microsoft.Network resource.

## Schema format

To create a Microsoft.Network, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Network/applicationGateways",
  "apiVersion": "2015-06-15",
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
              "id": "string"
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
          "requireServerNameIndication": "boolean",
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
  }
}
```
```
{
  "type": "Microsoft.Network/expressRouteCircuits/authorizations",
  "apiVersion": "2015-06-15",
  "properties": {
    "authorizationKey": "string",
    "authorizationUseStatus": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/expressRouteCircuits/peerings",
  "apiVersion": "2015-06-15",
  "properties": {
    "peeringType": "string",
    "state": "string",
    "azureASN": "integer",
    "peerASN": "integer",
    "primaryPeerAddressPrefix": "string",
    "secondaryPeerAddressPrefix": "string",
    "primaryAzurePort": "string",
    "secondaryAzurePort": "string",
    "sharedKey": "string",
    "vlanId": "integer",
    "microsoftPeeringConfig": {
      "advertisedPublicPrefixes": [
        "string"
      ],
      "advertisedPublicPrefixesState": "string",
      "customerASN": "integer",
      "routingRegistryName": "string"
    },
    "stats": {
      "bytesIn": "integer",
      "bytesOut": "integer"
    },
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/loadBalancers",
  "apiVersion": "2015-06-15",
  "properties": {
    "frontendIPConfigurations": [
      {
        "id": "string",
        "properties": {
          "inboundNatRules": [
            {
              "id": "string"
            }
          ],
          "inboundNatPools": [
            {
              "id": "string"
            }
          ],
          "outboundNatRules": [
            {
              "id": "string"
            }
          ],
          "loadBalancingRules": [
            {
              "id": "string"
            }
          ],
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
                          {
                            "id": "string",
                            "properties": {
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
                                    "enableFloatingIP": "boolean",
                                    "provisioningState": "string"
                                  },
                                  "name": "string",
                                  "etag": "string"
                                }
                              ],
                              "privateIPAddress": "string",
                              "privateIPAllocationMethod": "string",
                              "subnet": "Subnet",
                              "publicIPAddress": {
                                "id": "string",
                                "location": "string",
                                "tags": {},
                                "properties": {
                                  "publicIPAllocationMethod": "string",
                                  "ipConfiguration": {
                                    "id": "string",
                                    "properties": {
                                      "privateIPAddress": "string",
                                      "privateIPAllocationMethod": "string",
                                      "subnet": "Subnet",
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
                        "dnsSettings": {
                          "dnsServers": [
                            "string"
                          ],
                          "appliedDnsServers": [
                            "string"
                          ],
                          "internalDnsNameLabel": "string",
                          "internalFqdn": "string"
                        },
                        "macAddress": "string",
                        "primary": "boolean",
                        "enableIPForwarding": "boolean",
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
                                  {
                                    "id": "string",
                                    "properties": {
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
                                            "enableFloatingIP": "boolean",
                                            "provisioningState": "string"
                                          },
                                          "name": "string",
                                          "etag": "string"
                                        }
                                      ],
                                      "privateIPAddress": "string",
                                      "privateIPAllocationMethod": "string",
                                      "subnet": "Subnet",
                                      "publicIPAddress": "PublicIPAddress",
                                      "provisioningState": "string"
                                    },
                                    "name": "string",
                                    "etag": "string"
                                  }
                                ],
                                "dnsSettings": {
                                  "dnsServers": [
                                    "string"
                                  ],
                                  "appliedDnsServers": [
                                    "string"
                                  ],
                                  "internalDnsNameLabel": "string",
                                  "internalFqdn": "string"
                                },
                                "macAddress": "string",
                                "primary": "boolean",
                                "enableIPForwarding": "boolean",
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
    "backendAddressPools": [
      {
        "id": "string",
        "properties": {
          "backendIPConfigurations": [
            {
              "id": "string",
              "properties": {
                "loadBalancerBackendAddressPools": [
                  "BackendAddressPool"
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
                      "enableFloatingIP": "boolean",
                      "provisioningState": "string"
                    },
                    "name": "string",
                    "etag": "string"
                  }
                ],
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
                                "internalFqdn": "string"
                              },
                              "macAddress": "string",
                              "primary": "boolean",
                              "enableIPForwarding": "boolean",
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
                                        "internalFqdn": "string"
                                      },
                                      "macAddress": "string",
                                      "primary": "boolean",
                                      "enableIPForwarding": "boolean",
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
    "loadBalancingRules": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "backendAddressPool": {
            "id": "string"
          },
          "probe": {
            "id": "string"
          },
          "protocol": "string",
          "loadDistribution": "string",
          "frontendPort": "integer",
          "backendPort": "integer",
          "idleTimeoutInMinutes": "integer",
          "enableFloatingIP": "boolean",
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
          "loadBalancingRules": [
            {
              "id": "string"
            }
          ],
          "protocol": "string",
          "port": "integer",
          "intervalInSeconds": "integer",
          "numberOfProbes": "integer",
          "requestPath": "string",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "inboundNatRules": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "backendIPConfiguration": {
            "id": "string",
            "properties": {
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
                "InboundNatRule"
              ],
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
                              "internalFqdn": "string"
                            },
                            "macAddress": "string",
                            "primary": "boolean",
                            "enableIPForwarding": "boolean",
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
                                      "internalFqdn": "string"
                                    },
                                    "macAddress": "string",
                                    "primary": "boolean",
                                    "enableIPForwarding": "boolean",
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
          },
          "protocol": "string",
          "frontendPort": "integer",
          "backendPort": "integer",
          "idleTimeoutInMinutes": "integer",
          "enableFloatingIP": "boolean",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "inboundNatPools": [
      {
        "id": "string",
        "properties": {
          "frontendIPConfiguration": {
            "id": "string"
          },
          "protocol": "string",
          "frontendPortRangeStart": "integer",
          "frontendPortRangeEnd": "integer",
          "backendPort": "integer",
          "provisioningState": "string"
        },
        "name": "string",
        "etag": "string"
      }
    ],
    "outboundNatRules": [
      {
        "id": "string",
        "properties": {
          "allocatedOutboundPorts": "integer",
          "frontendIPConfigurations": [
            {
              "id": "string"
            }
          ],
          "backendAddressPool": {
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
  }
}
```
```
{
  "type": "Microsoft.Network/localNetworkGateways",
  "apiVersion": "2015-06-15",
  "properties": {
    "localNetworkAddressSpace": {
      "addressPrefixes": [
        "string"
      ]
    },
    "gatewayIpAddress": "string",
    "bgpSettings": {
      "asn": "integer",
      "bgpPeeringAddress": "string",
      "peerWeight": "integer"
    },
    "resourceGuid": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/networkInterfaces",
  "apiVersion": "2015-06-15",
  "properties": {
    "virtualMachine": {
      "id": "string"
    },
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
            "properties": "NetworkInterfacePropertiesFormat",
            "etag": "string"
          }
        ],
        "subnets": [
          {
            "id": "string",
            "properties": {
              "addressPrefix": "string",
              "networkSecurityGroup": "NetworkSecurityGroup",
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
          }
        ],
        "resourceGuid": "string",
        "provisioningState": "string"
      },
      "etag": "string"
    },
    "ipConfigurations": [
      {
        "id": "string",
        "properties": {
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
                "enableFloatingIP": "boolean",
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ],
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
                      "properties": "NetworkInterfacePropertiesFormat",
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
                              "properties": "NetworkInterfacePropertiesFormat",
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
    "dnsSettings": {
      "dnsServers": [
        "string"
      ],
      "appliedDnsServers": [
        "string"
      ],
      "internalDnsNameLabel": "string",
      "internalFqdn": "string"
    },
    "macAddress": "string",
    "primary": "boolean",
    "enableIPForwarding": "boolean",
    "resourceGuid": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/networkSecurityGroups",
  "apiVersion": "2015-06-15",
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
          "networkSecurityGroup": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": "NetworkSecurityGroupPropertiesFormat",
            "etag": "string"
          },
          "ipConfigurations": [
            {
              "id": "string",
              "properties": {
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
                      "enableFloatingIP": "boolean",
                      "provisioningState": "string"
                    },
                    "name": "string",
                    "etag": "string"
                  }
                ],
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
                      "properties": "NetworkSecurityGroupPropertiesFormat",
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
                              "properties": "NetworkSecurityGroupPropertiesFormat",
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
          "dnsSettings": {
            "dnsServers": [
              "string"
            ],
            "appliedDnsServers": [
              "string"
            ],
            "internalDnsNameLabel": "string",
            "internalFqdn": "string"
          },
          "macAddress": "string",
          "primary": "boolean",
          "enableIPForwarding": "boolean",
          "resourceGuid": "string",
          "provisioningState": "string"
        },
        "etag": "string"
      }
    ],
    "subnets": [
      {
        "id": "string",
        "properties": {
          "addressPrefix": "string",
          "networkSecurityGroup": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": "NetworkSecurityGroupPropertiesFormat",
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
      }
    ],
    "resourceGuid": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/publicIPAddresses",
  "apiVersion": "2015-06-15",
  "properties": {
    "publicIPAllocationMethod": "string",
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
                        {
                          "id": "string",
                          "properties": {
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
                                  "enableFloatingIP": "boolean",
                                  "provisioningState": "string"
                                },
                                "name": "string",
                                "etag": "string"
                              }
                            ],
                            "privateIPAddress": "string",
                            "privateIPAllocationMethod": "string",
                            "subnet": "Subnet",
                            "publicIPAddress": {
                              "id": "string",
                              "location": "string",
                              "tags": {},
                              "properties": "PublicIPAddressPropertiesFormat",
                              "etag": "string"
                            },
                            "provisioningState": "string"
                          },
                          "name": "string",
                          "etag": "string"
                        }
                      ],
                      "dnsSettings": {
                        "dnsServers": [
                          "string"
                        ],
                        "appliedDnsServers": [
                          "string"
                        ],
                        "internalDnsNameLabel": "string",
                        "internalFqdn": "string"
                      },
                      "macAddress": "string",
                      "primary": "boolean",
                      "enableIPForwarding": "boolean",
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
        "publicIPAddress": {
          "id": "string",
          "location": "string",
          "tags": {},
          "properties": "PublicIPAddressPropertiesFormat",
          "etag": "string"
        },
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
  }
}
```
```
{
  "type": "Microsoft.Network/routeTables",
  "apiVersion": "2015-06-15",
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
      {
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
                      {
                        "id": "string",
                        "properties": {
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
                                "enableFloatingIP": "boolean",
                                "provisioningState": "string"
                              },
                              "name": "string",
                              "etag": "string"
                            }
                          ],
                          "privateIPAddress": "string",
                          "privateIPAllocationMethod": "string",
                          "subnet": "Subnet",
                          "publicIPAddress": {
                            "id": "string",
                            "location": "string",
                            "tags": {},
                            "properties": {
                              "publicIPAllocationMethod": "string",
                              "ipConfiguration": {
                                "id": "string",
                                "properties": {
                                  "privateIPAddress": "string",
                                  "privateIPAllocationMethod": "string",
                                  "subnet": "Subnet",
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
                    "dnsSettings": {
                      "dnsServers": [
                        "string"
                      ],
                      "appliedDnsServers": [
                        "string"
                      ],
                      "internalDnsNameLabel": "string",
                      "internalFqdn": "string"
                    },
                    "macAddress": "string",
                    "primary": "boolean",
                    "enableIPForwarding": "boolean",
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
            "properties": "RouteTablePropertiesFormat",
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
      }
    ],
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/routeTables/routes",
  "apiVersion": "2015-06-15",
  "properties": {
    "addressPrefix": "string",
    "nextHopType": "string",
    "nextHopIpAddress": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/networkSecurityGroups/securityRules",
  "apiVersion": "2015-06-15",
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
  }
}
```
```
{
  "type": "Microsoft.Network/virtualnetworks/subnets",
  "apiVersion": "2015-06-15",
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
                {
                  "id": "string",
                  "properties": {
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
                          "enableFloatingIP": "boolean",
                          "provisioningState": "string"
                        },
                        "name": "string",
                        "etag": "string"
                      }
                    ],
                    "privateIPAddress": "string",
                    "privateIPAllocationMethod": "string",
                    "subnet": {
                      "id": "string",
                      "properties": "SubnetPropertiesFormat",
                      "name": "string",
                      "etag": "string"
                    },
                    "publicIPAddress": {
                      "id": "string",
                      "location": "string",
                      "tags": {},
                      "properties": {
                        "publicIPAllocationMethod": "string",
                        "ipConfiguration": {
                          "id": "string",
                          "properties": {
                            "privateIPAddress": "string",
                            "privateIPAllocationMethod": "string",
                            "subnet": {
                              "id": "string",
                              "properties": "SubnetPropertiesFormat",
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
              "dnsSettings": {
                "dnsServers": [
                  "string"
                ],
                "appliedDnsServers": [
                  "string"
                ],
                "internalDnsNameLabel": "string",
                "internalFqdn": "string"
              },
              "macAddress": "string",
              "primary": "boolean",
              "enableIPForwarding": "boolean",
              "resourceGuid": "string",
              "provisioningState": "string"
            },
            "etag": "string"
          }
        ],
        "subnets": [
          {
            "id": "string",
            "properties": "SubnetPropertiesFormat",
            "name": "string",
            "etag": "string"
          }
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
          {
            "id": "string",
            "properties": "SubnetPropertiesFormat",
            "name": "string",
            "etag": "string"
          }
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
          "subnet": {
            "id": "string",
            "properties": "SubnetPropertiesFormat",
            "name": "string",
            "etag": "string"
          },
          "publicIPAddress": {
            "id": "string",
            "location": "string",
            "tags": {},
            "properties": {
              "publicIPAllocationMethod": "string",
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
  }
}
```
```
{
  "type": "Microsoft.Network/connections",
  "apiVersion": "2015-06-15",
  "properties": {
    "authorizationKey": "string",
    "virtualNetworkGateway1": {
      "id": "string",
      "location": "string",
      "tags": {},
      "properties": {
        "ipConfigurations": [
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
        "gatewayType": "string",
        "vpnType": "string",
        "enableBgp": "boolean",
        "gatewayDefaultSite": {
          "id": "string"
        },
        "sku": {
          "name": "string",
          "tier": "string",
          "capacity": "integer"
        },
        "vpnClientConfiguration": {
          "vpnClientAddressPool": {
            "addressPrefixes": [
              "string"
            ]
          },
          "vpnClientRootCertificates": [
            {
              "id": "string",
              "properties": {
                "publicCertData": "string",
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ],
          "vpnClientRevokedCertificates": [
            {
              "id": "string",
              "properties": {
                "thumbprint": "string",
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ]
        },
        "bgpSettings": {
          "asn": "integer",
          "bgpPeeringAddress": "string",
          "peerWeight": "integer"
        },
        "resourceGuid": "string",
        "provisioningState": "string"
      },
      "etag": "string"
    },
    "virtualNetworkGateway2": {
      "id": "string",
      "location": "string",
      "tags": {},
      "properties": {
        "ipConfigurations": [
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
        "gatewayType": "string",
        "vpnType": "string",
        "enableBgp": "boolean",
        "gatewayDefaultSite": {
          "id": "string"
        },
        "sku": {
          "name": "string",
          "tier": "string",
          "capacity": "integer"
        },
        "vpnClientConfiguration": {
          "vpnClientAddressPool": {
            "addressPrefixes": [
              "string"
            ]
          },
          "vpnClientRootCertificates": [
            {
              "id": "string",
              "properties": {
                "publicCertData": "string",
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ],
          "vpnClientRevokedCertificates": [
            {
              "id": "string",
              "properties": {
                "thumbprint": "string",
                "provisioningState": "string"
              },
              "name": "string",
              "etag": "string"
            }
          ]
        },
        "bgpSettings": {
          "asn": "integer",
          "bgpPeeringAddress": "string",
          "peerWeight": "integer"
        },
        "resourceGuid": "string",
        "provisioningState": "string"
      },
      "etag": "string"
    },
    "localNetworkGateway2": {
      "id": "string",
      "location": "string",
      "tags": {},
      "properties": {
        "localNetworkAddressSpace": {
          "addressPrefixes": [
            "string"
          ]
        },
        "gatewayIpAddress": "string",
        "bgpSettings": {
          "asn": "integer",
          "bgpPeeringAddress": "string",
          "peerWeight": "integer"
        },
        "resourceGuid": "string",
        "provisioningState": "string"
      },
      "etag": "string"
    },
    "connectionType": "string",
    "routingWeight": "integer",
    "sharedKey": "string",
    "connectionStatus": "string",
    "egressBytesTransferred": "integer",
    "ingressBytesTransferred": "integer",
    "peer": {
      "id": "string"
    },
    "enableBgp": "boolean",
    "resourceGuid": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/virtualnetworkgateways",
  "apiVersion": "2015-06-15",
  "properties": {
    "ipConfigurations": [
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
    "gatewayType": "string",
    "vpnType": "string",
    "enableBgp": "boolean",
    "gatewayDefaultSite": {
      "id": "string"
    },
    "sku": {
      "name": "string",
      "tier": "string",
      "capacity": "integer"
    },
    "vpnClientConfiguration": {
      "vpnClientAddressPool": {
        "addressPrefixes": [
          "string"
        ]
      },
      "vpnClientRootCertificates": [
        {
          "id": "string",
          "properties": {
            "publicCertData": "string",
            "provisioningState": "string"
          },
          "name": "string",
          "etag": "string"
        }
      ],
      "vpnClientRevokedCertificates": [
        {
          "id": "string",
          "properties": {
            "thumbprint": "string",
            "provisioningState": "string"
          },
          "name": "string",
          "etag": "string"
        }
      ]
    },
    "bgpSettings": {
      "asn": "integer",
      "bgpPeeringAddress": "string",
      "peerWeight": "integer"
    },
    "resourceGuid": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.Network/virtualnetworks",
  "apiVersion": "2015-06-15",
  "properties": {
    "addressSpace": {
      "addressPrefixes": [
        "string"
      ]
    },
    "dhcpOptions": {
      "dnsServers": [
        "string"
      ]
    },
    "subnets": [
      {
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
                      {
                        "id": "string",
                        "properties": {
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
                                "enableFloatingIP": "boolean",
                                "provisioningState": "string"
                              },
                              "name": "string",
                              "etag": "string"
                            }
                          ],
                          "privateIPAddress": "string",
                          "privateIPAllocationMethod": "string",
                          "subnet": "Subnet",
                          "publicIPAddress": {
                            "id": "string",
                            "location": "string",
                            "tags": {},
                            "properties": {
                              "publicIPAllocationMethod": "string",
                              "ipConfiguration": {
                                "id": "string",
                                "properties": {
                                  "privateIPAddress": "string",
                                  "privateIPAllocationMethod": "string",
                                  "subnet": "Subnet",
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
                    "dnsSettings": {
                      "dnsServers": [
                        "string"
                      ],
                      "appliedDnsServers": [
                        "string"
                      ],
                      "internalDnsNameLabel": "string",
                      "internalFqdn": "string"
                    },
                    "macAddress": "string",
                    "primary": "boolean",
                    "enableIPForwarding": "boolean",
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
      }
    ],
    "resourceGuid": "string",
    "provisioningState": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="applicationGateways" />
## applicationGateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/applicationGateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[ApplicationGatewayPropertiesFormat object](#ApplicationGatewayPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="expressRouteCircuits_authorizations" />
## expressRouteCircuits_authorizations object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/expressRouteCircuits/authorizations**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[AuthorizationPropertiesFormat object](#AuthorizationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="expressRouteCircuits_peerings" />
## expressRouteCircuits_peerings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/expressRouteCircuits/peerings**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[ExpressRouteCircuitPeeringPropertiesFormat object](#ExpressRouteCircuitPeeringPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="loadBalancers" />
## loadBalancers object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/loadBalancers**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[LoadBalancerPropertiesFormat object](#LoadBalancerPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="localNetworkGateways" />
## localNetworkGateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/localNetworkGateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[LocalNetworkGatewayPropertiesFormat object](#LocalNetworkGatewayPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="networkInterfaces" />
## networkInterfaces object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/networkInterfaces**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[NetworkInterfacePropertiesFormat object](#NetworkInterfacePropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="networkSecurityGroups" />
## networkSecurityGroups object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/networkSecurityGroups**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[NetworkSecurityGroupPropertiesFormat object](#NetworkSecurityGroupPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |
|  resources | No | array<br />[securityRules object](#securityRules)<br /> |


<a id="publicIPAddresses" />
## publicIPAddresses object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/publicIPAddresses**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[PublicIPAddressPropertiesFormat object](#PublicIPAddressPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="routeTables" />
## routeTables object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/routeTables**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[RouteTablePropertiesFormat object](#RouteTablePropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |
|  resources | No | array<br />[routes object](#routes)<br /> |


<a id="routeTables_routes" />
## routeTables_routes object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/routeTables/routes**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[RoutePropertiesFormat object](#RoutePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="networkSecurityGroups_securityRules" />
## networkSecurityGroups_securityRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/networkSecurityGroups/securityRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="virtualnetworks_subnets" />
## virtualnetworks_subnets object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/virtualnetworks/subnets**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[SubnetPropertiesFormat object](#SubnetPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="connections" />
## connections object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/connections**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VirtualNetworkGatewayConnectionPropertiesFormat object](#VirtualNetworkGatewayConnectionPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="virtualnetworkgateways" />
## virtualnetworkgateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/virtualnetworkgateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VirtualNetworkGatewayPropertiesFormat object](#VirtualNetworkGatewayPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="virtualnetworks" />
## virtualnetworks object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Network/virtualnetworks**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VirtualNetworkPropertiesFormat object](#VirtualNetworkPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |
|  resources | No | array<br />[subnets object](#subnets)<br /> |


<a id="ApplicationGatewayPropertiesFormat" />
## ApplicationGatewayPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  sku | No | object<br />[ApplicationGatewaySku object](#ApplicationGatewaySku)<br /><br />Gets or sets sku of application gateway resource |
|  gatewayIPConfigurations | No | array<br />[ApplicationGatewayIPConfiguration object](#ApplicationGatewayIPConfiguration)<br /><br />Gets or sets subnets of application gateway resource |
|  sslCertificates | No | array<br />[ApplicationGatewaySslCertificate object](#ApplicationGatewaySslCertificate)<br /><br />Gets or sets ssl certificates of application gateway resource |
|  frontendIPConfigurations | No | array<br />[ApplicationGatewayFrontendIPConfiguration object](#ApplicationGatewayFrontendIPConfiguration)<br /><br />Gets or sets frontend IP addresses of application gateway resource |
|  frontendPorts | No | array<br />[ApplicationGatewayFrontendPort object](#ApplicationGatewayFrontendPort)<br /><br />Gets or sets frontend ports of application gateway resource |
|  probes | No | array<br />[ApplicationGatewayProbe object](#ApplicationGatewayProbe)<br /><br />Gets or sets probes of application gateway resource |
|  backendAddressPools | No | array<br />[ApplicationGatewayBackendAddressPool object](#ApplicationGatewayBackendAddressPool)<br /><br />Gets or sets backend address pool of application gateway resource |
|  backendHttpSettingsCollection | No | array<br />[ApplicationGatewayBackendHttpSettings object](#ApplicationGatewayBackendHttpSettings)<br /><br />Gets or sets backend http settings of application gateway resource |
|  httpListeners | No | array<br />[ApplicationGatewayHttpListener object](#ApplicationGatewayHttpListener)<br /><br />Gets or sets HTTP listeners of application gateway resource |
|  urlPathMaps | No | array<br />[ApplicationGatewayUrlPathMap object](#ApplicationGatewayUrlPathMap)<br /><br />Gets or sets URL path map of application gateway resource |
|  requestRoutingRules | No | array<br />[ApplicationGatewayRequestRoutingRule object](#ApplicationGatewayRequestRoutingRule)<br /><br />Gets or sets request routing rules of application gateway resource |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the ApplicationGateway resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the ApplicationGateway resource Updating/Deleting/Failed |


<a id="ApplicationGatewaySku" />
## ApplicationGatewaySku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Standard_Small**, **Standard_Medium**, **Standard_Large**<br /><br />Gets or sets name of application gateway SKU. |
|  tier | No | enum<br />**Standard**<br /><br />Gets or sets tier of application gateway. |
|  capacity | No | integer<br /><br />Gets or sets capacity (instance count) of application gateway |


<a id="ApplicationGatewayIPConfiguration" />
## ApplicationGatewayIPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayIPConfigurationPropertiesFormat object](#ApplicationGatewayIPConfigurationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayIPConfigurationPropertiesFormat" />
## ApplicationGatewayIPConfigurationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  subnet | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the subnet resource.A subnet from where appliation gateway gets its private address  |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the application gateway subnet resource Updating/Deleting/Failed |


<a id="SubResource" />
## SubResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |


<a id="ApplicationGatewaySslCertificate" />
## ApplicationGatewaySslCertificate object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewaySslCertificatePropertiesFormat object](#ApplicationGatewaySslCertificatePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewaySslCertificatePropertiesFormat" />
## ApplicationGatewaySslCertificatePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  data | No | string<br /><br />Gets or sets the certificate data  |
|  password | No | string<br /><br />Gets or sets the certificate password  |
|  publicCertData | No | string<br /><br />Gets or sets the certificate public data  |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the ssl certificate resource Updating/Deleting/Failed |


<a id="ApplicationGatewayFrontendIPConfiguration" />
## ApplicationGatewayFrontendIPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayFrontendIPConfigurationPropertiesFormat object](#ApplicationGatewayFrontendIPConfigurationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayFrontendIPConfigurationPropertiesFormat" />
## ApplicationGatewayFrontendIPConfigurationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  privateIPAddress | No | string<br /><br />Gets or sets the privateIPAddress of the Network Interface IP Configuration |
|  privateIPAllocationMethod | No | enum<br />**Static** or **Dynamic**<br /><br />Gets or sets PrivateIP allocation method (Static/Dynamic). |
|  subnet | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the subnet resource |
|  publicIPAddress | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the PublicIP resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ApplicationGatewayFrontendPort" />
## ApplicationGatewayFrontendPort object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayFrontendPortPropertiesFormat object](#ApplicationGatewayFrontendPortPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayFrontendPortPropertiesFormat" />
## ApplicationGatewayFrontendPortPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  port | No | integer<br /><br />Gets or sets the frontend port |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the frontend port resource Updating/Deleting/Failed |


<a id="ApplicationGatewayProbe" />
## ApplicationGatewayProbe object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayProbePropertiesFormat object](#ApplicationGatewayProbePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayProbePropertiesFormat" />
## ApplicationGatewayProbePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  protocol | No | enum<br />**Http** or **Https**<br /><br />Gets or sets the protocol. |
|  host | No | string<br /><br />Gets or sets the host to send probe to  |
|  path | No | string<br /><br />Gets or sets the relative path of probe  |
|  interval | No | integer<br /><br />Gets or sets probing interval in seconds  |
|  timeout | No | integer<br /><br />Gets or sets probing timeout in seconds  |
|  unhealthyThreshold | No | integer<br /><br />Gets or sets probing unhealthy threshold  |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayBackendAddressPool" />
## ApplicationGatewayBackendAddressPool object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayBackendAddressPoolPropertiesFormat object](#ApplicationGatewayBackendAddressPoolPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendAddressPoolPropertiesFormat" />
## ApplicationGatewayBackendAddressPoolPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  backendIPConfigurations | No | array<br />[SubResource object](#SubResource)<br /><br />Gets or sets backendIPConfiguration of application gateway  |
|  backendAddresses | No | array<br />[ApplicationGatewayBackendAddress object](#ApplicationGatewayBackendAddress)<br /><br />Gets or sets the backend addresses |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the backend address pool resource Updating/Deleting/Failed |


<a id="ApplicationGatewayBackendAddress" />
## ApplicationGatewayBackendAddress object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  fqdn | No | string<br /><br />Gets or sets the dns name |
|  ipAddress | No | string<br /><br />Gets or sets the ip address |


<a id="ApplicationGatewayBackendHttpSettings" />
## ApplicationGatewayBackendHttpSettings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayBackendHttpSettingsPropertiesFormat object](#ApplicationGatewayBackendHttpSettingsPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayBackendHttpSettingsPropertiesFormat" />
## ApplicationGatewayBackendHttpSettingsPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  port | No | integer<br /><br />Gets or sets the port |
|  protocol | No | enum<br />**Http** or **Https**<br /><br />Gets or sets the protocol. |
|  cookieBasedAffinity | No | enum<br />**Enabled** or **Disabled**<br /><br />Gets or sets the cookie affinity. |
|  requestTimeout | No | integer<br /><br />Gets or sets request timeout |
|  probe | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets probe resource of application gateway  |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayHttpListener" />
## ApplicationGatewayHttpListener object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayHttpListenerPropertiesFormat object](#ApplicationGatewayHttpListenerPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayHttpListenerPropertiesFormat" />
## ApplicationGatewayHttpListenerPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frontendIPConfiguration | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets frontend IP configuration resource of application gateway  |
|  frontendPort | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets frontend port resource of application gateway  |
|  protocol | No | enum<br />**Http** or **Https**<br /><br />Gets or sets the protocol. |
|  hostName | No | string<br /><br />Gets or sets the host name of http listener  |
|  sslCertificate | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets ssl certificate resource of application gateway  |
|  requireServerNameIndication | No | boolean<br /><br />Gets or sets the requireServerNameIndication of http listener  |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the http listener resource Updating/Deleting/Failed |


<a id="ApplicationGatewayUrlPathMap" />
## ApplicationGatewayUrlPathMap object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayUrlPathMapPropertiesFormat object](#ApplicationGatewayUrlPathMapPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayUrlPathMapPropertiesFormat" />
## ApplicationGatewayUrlPathMapPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  defaultBackendAddressPool | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets default backend address pool resource of URL path map  |
|  defaultBackendHttpSettings | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets default backend http settings resource of URL path map  |
|  pathRules | No | array<br />[ApplicationGatewayPathRule object](#ApplicationGatewayPathRule)<br /><br />Gets or sets path rule of URL path map resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the backend http settings resource Updating/Deleting/Failed |


<a id="ApplicationGatewayPathRule" />
## ApplicationGatewayPathRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayPathRulePropertiesFormat object](#ApplicationGatewayPathRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayPathRulePropertiesFormat" />
## ApplicationGatewayPathRulePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  paths | No | array<br />**string**<br /><br />Gets or sets the path rules of URL path map |
|  backendAddressPool | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets backend address pool resource of URL path map  |
|  backendHttpSettings | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets backend http settings resource of URL path map  |
|  provisioningState | No | string<br /><br />Gets or sets path rule of URL path map resource Updating/Deleting/Failed |


<a id="ApplicationGatewayRequestRoutingRule" />
## ApplicationGatewayRequestRoutingRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ApplicationGatewayRequestRoutingRulePropertiesFormat object](#ApplicationGatewayRequestRoutingRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ApplicationGatewayRequestRoutingRulePropertiesFormat" />
## ApplicationGatewayRequestRoutingRulePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  ruleType | No | enum<br />**Basic** or **PathBasedRouting**<br /><br />Gets or sets the rule type. |
|  backendAddressPool | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets backend address pool resource of application gateway  |
|  backendHttpSettings | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets frontend port resource of application gateway  |
|  httpListener | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets http listener resource of application gateway  |
|  urlPathMap | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets url path map resource of application gateway  |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the request routing rule resource Updating/Deleting/Failed |


<a id="AuthorizationPropertiesFormat" />
## AuthorizationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  authorizationKey | No | string<br /><br />Gets or sets the authorization key |
|  authorizationUseStatus | No | enum<br />**Available** or **InUse**<br /><br />Gets or sets AuthorizationUseStatus. |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ExpressRouteCircuitPeeringPropertiesFormat" />
## ExpressRouteCircuitPeeringPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  peeringType | No | enum<br />**AzurePublicPeering**, **AzurePrivatePeering**, **MicrosoftPeering**<br /><br />Gets or sets PeeringType. |
|  state | No | enum<br />**Disabled** or **Enabled**<br /><br />Gets or sets state of Peering. |
|  azureASN | No | integer<br /><br />Gets or sets the azure ASN |
|  peerASN | No | integer<br /><br />Gets or sets the peer ASN |
|  primaryPeerAddressPrefix | No | string<br /><br />Gets or sets the primary address prefix |
|  secondaryPeerAddressPrefix | No | string<br /><br />Gets or sets the secondary address prefix |
|  primaryAzurePort | No | string<br /><br />Gets or sets the primary port |
|  secondaryAzurePort | No | string<br /><br />Gets or sets the secondary port |
|  sharedKey | No | string<br /><br />Gets or sets the shared key |
|  vlanId | No | integer<br /><br />Gets or sets the vlan id |
|  microsoftPeeringConfig | No | object<br />[ExpressRouteCircuitPeeringConfig object](#ExpressRouteCircuitPeeringConfig)<br /><br />Gets or sets the mircosoft peering config |
|  stats | No | object<br />[ExpressRouteCircuitStats object](#ExpressRouteCircuitStats)<br /><br />Gets or peering stats |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="ExpressRouteCircuitPeeringConfig" />
## ExpressRouteCircuitPeeringConfig object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  advertisedPublicPrefixes | No | array<br />**string**<br /><br />Gets or sets the reference of AdvertisedPublicPrefixes |
|  advertisedPublicPrefixesState | No | enum<br />**NotConfigured**, **Configuring**, **Configured**, **ValidationNeeded**<br /><br />Gets or sets AdvertisedPublicPrefixState of the Peering resource. |
|  customerASN | No | integer<br /><br />Gets or Sets CustomerAsn of the peering. |
|  routingRegistryName | No | string<br /><br />Gets or Sets RoutingRegistryName of the config. |


<a id="ExpressRouteCircuitStats" />
## ExpressRouteCircuitStats object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  bytesIn | No | integer<br /><br />Gets BytesIn of the peering. |
|  bytesOut | No | integer<br /><br />Gets BytesOut of the peering. |


<a id="LoadBalancerPropertiesFormat" />
## LoadBalancerPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frontendIPConfigurations | No | array<br />[FrontendIPConfiguration object](#FrontendIPConfiguration)<br /><br />Gets or sets frontend IP addresses of the load balancer |
|  backendAddressPools | No | array<br />[BackendAddressPool object](#BackendAddressPool)<br /><br />Gets or sets Pools of backend IP addresseses |
|  loadBalancingRules | No | array<br />[LoadBalancingRule object](#LoadBalancingRule)<br /><br />Gets or sets loadbalancing rules |
|  probes | No | array<br />[Probe object](#Probe)<br /><br />Gets or sets list of Load balancer probes |
|  inboundNatRules | No | array<br />[InboundNatRule object](#InboundNatRule)<br /><br />Gets or sets list of inbound rules |
|  inboundNatPools | No | array<br />[InboundNatPool object](#InboundNatPool)<br /><br />Gets or sets inbound NAT pools |
|  outboundNatRules | No | array<br />[OutboundNatRule object](#OutboundNatRule)<br /><br />Gets or sets outbound NAT rules |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the Load balancer resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="FrontendIPConfiguration" />
## FrontendIPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[FrontendIPConfigurationPropertiesFormat object](#FrontendIPConfigurationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="FrontendIPConfigurationPropertiesFormat" />
## FrontendIPConfigurationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  inboundNatRules | No | array<br />[SubResource object](#SubResource)<br /><br />Read only.Inbound rules URIs that use this frontend IP |
|  inboundNatPools | No | array<br />[SubResource object](#SubResource)<br /><br />Read only.Inbound pools URIs that use this frontend IP |
|  outboundNatRules | No | array<br />[SubResource object](#SubResource)<br /><br />Read only.Outbound rules URIs that use this frontend IP |
|  loadBalancingRules | No | array<br />[SubResource object](#SubResource)<br /><br />Gets Load Balancing rules URIs that use this frontend IP |
|  privateIPAddress | No | string<br /><br />Gets or sets the privateIPAddress of the IP Configuration |
|  privateIPAllocationMethod | No | enum<br />**Static** or **Dynamic**<br /><br />Gets or sets PrivateIP allocation method (Static/Dynamic). |
|  subnet | No | object<br />[Subnet object](#Subnet)<br /><br />Gets or sets the reference of the subnet resource |
|  publicIPAddress | No | object<br />[PublicIPAddress object](#PublicIPAddress)<br /><br />Gets or sets the reference of the PublicIP resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="Subnet" />
## Subnet object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[SubnetPropertiesFormat object](#SubnetPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="SubnetPropertiesFormat" />
## SubnetPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  addressPrefix | No | string<br /><br />Gets or sets Address prefix for the subnet. |
|  networkSecurityGroup | No | object<br />[NetworkSecurityGroup object](#NetworkSecurityGroup)<br /><br />Gets or sets the reference of the NetworkSecurityGroup resource |
|  routeTable | No | object<br />[RouteTable object](#RouteTable)<br /><br />Gets or sets the reference of the RouteTable resource |
|  ipConfigurations | No | array<br />[IPConfiguration object](#IPConfiguration)<br /><br />Gets array of references to the network interface IP configurations using subnet |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="NetworkSecurityGroup" />
## NetworkSecurityGroup object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[NetworkSecurityGroupPropertiesFormat object](#NetworkSecurityGroupPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="NetworkSecurityGroupPropertiesFormat" />
## NetworkSecurityGroupPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  securityRules | No | array<br />[SecurityRule object](#SecurityRule)<br /><br />Gets or sets Security rules of network security group |
|  defaultSecurityRules | No | array<br />[SecurityRule object](#SecurityRule)<br /><br />Gets or sets Default security rules of network security group |
|  networkInterfaces | No | array<br />[NetworkInterface object](#NetworkInterface)<br /><br />Gets collection of references to Network Interfaces |
|  subnets | No | array<br />[Subnet object](#Subnet)<br /><br />Gets collection of references to subnets |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the network security group resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="SecurityRule" />
## SecurityRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="SecurityRulePropertiesFormat" />
## SecurityRulePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  description | No | string<br /><br />Gets or sets a description for this rule. Restricted to 140 chars. |
|  protocol | Yes | enum<br />**Tcp**, **Udp**, *****<br /><br />Gets or sets Network protocol this rule applies to. Can be Tcp, Udp or All(*). |
|  sourcePortRange | No | string<br /><br />Gets or sets Source Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  destinationPortRange | No | string<br /><br />Gets or sets Destination Port or Range. Integer or range between 0 and 65535. Asterix '*' can also be used to match all ports. |
|  sourceAddressPrefix | Yes | string<br /><br />Gets or sets source address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from.  |
|  destinationAddressPrefix | Yes | string<br /><br />Gets or sets destination address prefix. CIDR or source IP range. Asterix '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.  |
|  access | Yes | enum<br />**Allow** or **Deny**<br /><br />Gets or sets network traffic is allowed or denied. Possible values are 'Allow' and 'Deny'. |
|  priority | No | integer<br /><br />Gets or sets the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
|  direction | Yes | enum<br />**Inbound** or **Outbound**<br /><br />Gets or sets the direction of the rule.InBound or Outbound. The direction specifies if rule will be evaluated on incoming or outcoming traffic. |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="NetworkInterface" />
## NetworkInterface object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[NetworkInterfacePropertiesFormat object](#NetworkInterfacePropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterfacePropertiesFormat" />
## NetworkInterfacePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  virtualMachine | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of a VirtualMachine |
|  networkSecurityGroup | No | object<br />[NetworkSecurityGroup object](#NetworkSecurityGroup)<br /><br />Gets or sets the reference of the NetworkSecurityGroup resource |
|  ipConfigurations | No | array<br />[NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration)<br /><br />Gets or sets list of IPConfigurations of the NetworkInterface |
|  dnsSettings | No | object<br />[NetworkInterfaceDnsSettings object](#NetworkInterfaceDnsSettings)<br /><br />Gets or sets DNS Settings in  NetworkInterface |
|  macAddress | No | string<br /><br />Gets the MAC Address of the network interface |
|  primary | No | boolean<br /><br />Gets whether this is a primary NIC on a virtual machine |
|  enableIPForwarding | No | boolean<br /><br />Gets or sets whether IPForwarding is enabled on the NIC |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the network interface resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="NetworkInterfaceIPConfiguration" />
## NetworkInterfaceIPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[NetworkInterfaceIPConfigurationPropertiesFormat object](#NetworkInterfaceIPConfigurationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="NetworkInterfaceIPConfigurationPropertiesFormat" />
## NetworkInterfaceIPConfigurationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  loadBalancerBackendAddressPools | No | array<br />[BackendAddressPool object](#BackendAddressPool)<br /><br />Gets or sets the reference of LoadBalancerBackendAddressPool resource |
|  loadBalancerInboundNatRules | No | array<br />[InboundNatRule object](#InboundNatRule)<br /><br />Gets or sets list of references of LoadBalancerInboundNatRules |
|  privateIPAddress | No | string<br /> |
|  privateIPAllocationMethod | No | enum<br />**Static** or **Dynamic**<br /><br />Gets or sets PrivateIP allocation method (Static/Dynamic). |
|  subnet | No | object<br />[Subnet object](#Subnet)<br /> |
|  publicIPAddress | No | object<br />[PublicIPAddress object](#PublicIPAddress)<br /> |
|  provisioningState | No | string<br /> |


<a id="BackendAddressPool" />
## BackendAddressPool object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[BackendAddressPoolPropertiesFormat object](#BackendAddressPoolPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="BackendAddressPoolPropertiesFormat" />
## BackendAddressPoolPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  backendIPConfigurations | No | array<br />[NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration)<br /><br />Gets collection of references to IPs defined in NICs |
|  loadBalancingRules | No | array<br />[SubResource object](#SubResource)<br /><br />Gets Load Balancing rules that use this Backend Address Pool |
|  outboundNatRule | No | object<br />[SubResource object](#SubResource)<br /><br />Gets outbound rules that use this Backend Address Pool |
|  provisioningState | No | string<br /><br />Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatRule" />
## InboundNatRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[InboundNatRulePropertiesFormat object](#InboundNatRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="InboundNatRulePropertiesFormat" />
## InboundNatRulePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frontendIPConfiguration | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets a reference to frontend IP Addresses |
|  backendIPConfiguration | No | object<br />[NetworkInterfaceIPConfiguration object](#NetworkInterfaceIPConfiguration)<br /><br />Gets or sets a reference to a private ip address defined on a NetworkInterface of a VM. Traffic sent to frontendPort of each of the frontendIPConfigurations is forwarded to the backed IP |
|  protocol | No | enum<br />**Udp** or **Tcp**<br /><br />Gets or sets the transport potocol for the external endpoint. Possible values are Udp or Tcp. |
|  frontendPort | No | integer<br /><br />Gets or sets the port for the external endpoint. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | No | integer<br /><br />Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | No | integer<br /><br />Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This emlement is only used when the protocol is set to Tcp |
|  enableFloatingIP | No | boolean<br /><br />Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="PublicIPAddress" />
## PublicIPAddress object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[PublicIPAddressPropertiesFormat object](#PublicIPAddressPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="PublicIPAddressPropertiesFormat" />
## PublicIPAddressPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publicIPAllocationMethod | No | enum<br />**Static** or **Dynamic**<br /><br />Gets or sets PublicIP allocation method (Static/Dynamic). |
|  ipConfiguration | No | object<br />[IPConfiguration object](#IPConfiguration)<br /> |
|  dnsSettings | No | object<br />[PublicIPAddressDnsSettings object](#PublicIPAddressDnsSettings)<br /><br />Gets or sets FQDN of the DNS record associated with the public IP address |
|  ipAddress | No | string<br /> |
|  idleTimeoutInMinutes | No | integer<br /><br />Gets or sets the Idletimeout of the public IP address |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the PublicIP resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="IPConfiguration" />
## IPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[IPConfigurationPropertiesFormat object](#IPConfigurationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="IPConfigurationPropertiesFormat" />
## IPConfigurationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  privateIPAddress | No | string<br /><br />Gets or sets the privateIPAddress of the IP Configuration |
|  privateIPAllocationMethod | No | enum<br />**Static** or **Dynamic**<br /><br />Gets or sets PrivateIP allocation method (Static/Dynamic). |
|  subnet | No | object<br />[Subnet object](#Subnet)<br /><br />Gets or sets the reference of the subnet resource |
|  publicIPAddress | No | object<br />[PublicIPAddress object](#PublicIPAddress)<br /><br />Gets or sets the reference of the PublicIP resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="PublicIPAddressDnsSettings" />
## PublicIPAddressDnsSettings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  domainNameLabel | No | string<br /><br />Gets or sets the Domain name label.The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
|  fqdn | No | string<br /><br />Gets the FQDN, Fully qualified domain name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
|  reverseFqdn | No | string<br /><br />Gets or Sests the Reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.  |


<a id="NetworkInterfaceDnsSettings" />
## NetworkInterfaceDnsSettings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  dnsServers | No | array<br />**string**<br /><br />Gets or sets list of DNS servers IP addresses |
|  appliedDnsServers | No | array<br />**string**<br /><br />Gets or sets list of Applied DNS servers IP addresses |
|  internalDnsNameLabel | No | string<br /><br />Gets or sets the Internal DNS name |
|  internalFqdn | No | string<br /><br />Gets or sets full IDNS name in the form, DnsName.VnetId.ZoneId.TopleveSuffix. This is set when the NIC is associated to a VM |


<a id="RouteTable" />
## RouteTable object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[RouteTablePropertiesFormat object](#RouteTablePropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="RouteTablePropertiesFormat" />
## RouteTablePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  routes | No | array<br />[Route object](#Route)<br /><br />Gets or sets Routes in a Route Table |
|  subnets | No | array<br />[Subnet object](#Subnet)<br /><br />Gets collection of references to subnets |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the resource Updating/Deleting/Failed |


<a id="Route" />
## Route object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[RoutePropertiesFormat object](#RoutePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="RoutePropertiesFormat" />
## RoutePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  addressPrefix | No | string<br /><br />Gets or sets the destination CIDR to which the route applies. |
|  nextHopType | Yes | enum<br />**VirtualNetworkGateway**, **VnetLocal**, **Internet**, **VirtualAppliance**, **None**<br /><br />Gets or sets the type of Azure hop the packet should be sent to. |
|  nextHopIpAddress | No | string<br /><br />Gets or sets the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the resource Updating/Deleting/Failed |


<a id="LoadBalancingRule" />
## LoadBalancingRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[LoadBalancingRulePropertiesFormat object](#LoadBalancingRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="LoadBalancingRulePropertiesFormat" />
## LoadBalancingRulePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frontendIPConfiguration | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets a reference to frontend IP Addresses |
|  backendAddressPool | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets  a reference to a pool of DIPs. Inbound traffic is randomly load balanced across IPs in the backend IPs |
|  probe | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the load balancer probe used by the Load Balancing rule. |
|  protocol | Yes | enum<br />**Udp** or **Tcp**<br /><br />Gets or sets the transport protocol for the external endpoint. Possible values are Udp or Tcp. |
|  loadDistribution | No | enum<br />**Default**, **SourceIP**, **SourceIPProtocol**<br /><br />Gets or sets the load distribution policy for this rule. |
|  frontendPort | Yes | integer<br /><br />Gets or sets the port for the external endpoint. You can specify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | No | integer<br /><br />Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  idleTimeoutInMinutes | No | integer<br /><br />Gets or sets the timeout for the Tcp idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This emlement is only used when the protocol is set to Tcp |
|  enableFloatingIP | No | boolean<br /><br />Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn availability Group. This setting is required when using the SQL Always ON availability Groups in SQL server. This setting can't be changed after you create the endpoint |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="Probe" />
## Probe object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[ProbePropertiesFormat object](#ProbePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="ProbePropertiesFormat" />
## ProbePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  loadBalancingRules | No | array<br />[SubResource object](#SubResource)<br /><br />Gets Load balancer rules that use this probe |
|  protocol | Yes | enum<br />**Http** or **Tcp**<br /><br />Gets or sets the protocol of the end point. Possible values are http pr Tcp. If Tcp is specified, a received ACK is required for the probe to be successful. If http is specified,a 200 OK response from the specifies URI is required for the probe to be successful. |
|  port | Yes | integer<br /><br />Gets or sets Port for communicating the probe. Possible values range from 1 to 65535, inclusive. |
|  intervalInSeconds | No | integer<br /><br />Gets or sets the interval, in seconds, for how frequently to probe the endpoint for health status. Typically, the interval is slightly less than half the allocated timeout period (in seconds) which allows two full probes before taking the instance out of rotation. The default value is 15, the minimum value is 5 |
|  numberOfProbes | No | integer<br /><br />Gets or sets the number of probes where if no response, will result in stopping further traffic from being delivered to the endpoint. This values allows endponints to be taken out of rotation faster or slower than the typical times used in Azure.  |
|  requestPath | No | string<br /><br />Gets or sets the URI used for requesting health status from the VM. Path is required if a protocol is set to http. Otherwise, it is not allowed. There is no default value |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="InboundNatPool" />
## InboundNatPool object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[InboundNatPoolPropertiesFormat object](#InboundNatPoolPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="InboundNatPoolPropertiesFormat" />
## InboundNatPoolPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  frontendIPConfiguration | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets a reference to frontend IP Addresses |
|  protocol | Yes | enum<br />**Udp** or **Tcp**<br /><br />Gets or sets the transport potocol for the external endpoint. Possible values are Udp or Tcp. |
|  frontendPortRangeStart | Yes | integer<br /><br />Gets or sets the starting port range for the NAT pool. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  frontendPortRangeEnd | Yes | integer<br /><br />Gets or sets the ending port range for the NAT pool. You can spcify any port number you choose, but the port numbers specified for each role in the service must be unique. Possible values range between 1 and 65535, inclusive |
|  backendPort | Yes | integer<br /><br />Gets or sets a port used for internal connections on the endpoint. The localPort attribute maps the eternal port of the endpoint to an internal port on a role. This is useful in scenarios where a role must communicate to an internal compotnent on a port that is different from the one that is exposed externally. If not specified, the value of localPort is the same as the port attribute. Set the value of localPort to '*' to automatically assign an unallocated port that is discoverable using the runtime API |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="OutboundNatRule" />
## OutboundNatRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[OutboundNatRulePropertiesFormat object](#OutboundNatRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="OutboundNatRulePropertiesFormat" />
## OutboundNatRulePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  allocatedOutboundPorts | No | integer<br /><br />Gets or sets the number of outbound ports to be used for SNAT |
|  frontendIPConfigurations | No | array<br />[SubResource object](#SubResource)<br /><br />Gets or sets Frontend IP addresses of the load balancer |
|  backendAddressPool | Yes | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets a reference to a pool of DIPs. Outbound traffic is randomly load balanced across IPs in the backend IPs |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="LocalNetworkGatewayPropertiesFormat" />
## LocalNetworkGatewayPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  localNetworkAddressSpace | No | object<br />[AddressSpace object](#AddressSpace)<br /><br />Local network site Address space |
|  gatewayIpAddress | No | string<br /><br />IP address of local network gateway. |
|  bgpSettings | No | object<br />[BgpSettings object](#BgpSettings)<br /><br />Local network gateway's BGP speaker settings |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the LocalNetworkGateway resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the LocalNetworkGateway resource Updating/Deleting/Failed |


<a id="AddressSpace" />
## AddressSpace object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  addressPrefixes | No | array<br />**string**<br /><br />Gets or sets List of address blocks reserved for this virtual network in CIDR notation |


<a id="BgpSettings" />
## BgpSettings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  asn | No | integer<br /><br />Gets or sets this BGP speaker's ASN |
|  bgpPeeringAddress | No | string<br /><br />Gets or sets the BGP peering address and BGP identifier of this BGP speaker |
|  peerWeight | No | integer<br /><br />Gets or sets the weight added to routes learned from this BGP speaker |


<a id="VirtualNetworkGatewayConnectionPropertiesFormat" />
## VirtualNetworkGatewayConnectionPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  authorizationKey | No | string<br /><br />The authorizationKey. |
|  virtualNetworkGateway1 | No | object<br />[VirtualNetworkGateway object](#VirtualNetworkGateway)<br /> |
|  virtualNetworkGateway2 | No | object<br />[VirtualNetworkGateway object](#VirtualNetworkGateway)<br /> |
|  localNetworkGateway2 | No | object<br />[LocalNetworkGateway object](#LocalNetworkGateway)<br /> |
|  connectionType | No | enum<br />**IPsec**, **Vnet2Vnet**, **ExpressRoute**, **VPNClient**<br /><br />Gateway connection type -Ipsec/Dedicated/VpnClient/Vnet2Vnet. |
|  routingWeight | No | integer<br /><br />The Routing weight. |
|  sharedKey | No | string<br /><br />The Ipsec share key. |
|  connectionStatus | No | enum<br />**Unknown**, **Connecting**, **Connected**, **NotConnected**<br /><br />Virtual network Gateway connection status. |
|  egressBytesTransferred | No | integer<br /><br />The Egress Bytes Transferred in this connection |
|  ingressBytesTransferred | No | integer<br /><br />The Ingress Bytes Transferred in this connection |
|  peer | No | object<br />[SubResource object](#SubResource)<br /><br />The reference to peerings resource. |
|  enableBgp | No | boolean<br /><br />EnableBgp Flag |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the VirtualNetworkGatewayConnection resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the VirtualNetworkGatewayConnection resource Updating/Deleting/Failed |


<a id="VirtualNetworkGateway" />
## VirtualNetworkGateway object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[VirtualNetworkGatewayPropertiesFormat object](#VirtualNetworkGatewayPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkGatewayPropertiesFormat" />
## VirtualNetworkGatewayPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  ipConfigurations | No | array<br />[VirtualNetworkGatewayIPConfiguration object](#VirtualNetworkGatewayIPConfiguration)<br /><br />IpConfigurations for Virtual network gateway. |
|  gatewayType | No | enum<br />**Vpn** or **ExpressRoute**<br /><br />The type of this virtual network gateway. |
|  vpnType | No | enum<br />**PolicyBased** or **RouteBased**<br /><br />The type of this virtual network gateway. |
|  enableBgp | No | boolean<br /><br />EnableBgp Flag |
|  gatewayDefaultSite | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the LocalNetworkGateway resource which represents Local network site having default routes. Assign Null value in case of removing existing default site setting. |
|  sku | No | object<br />[VirtualNetworkGatewaySku object](#VirtualNetworkGatewaySku)<br /><br />Gets or sets the reference of the VirtualNetworkGatewaySku resource which represents the sku selected for Virtual network gateway. |
|  vpnClientConfiguration | No | object<br />[VpnClientConfiguration object](#VpnClientConfiguration)<br /><br />Gets or sets the reference of the VpnClientConfiguration resource which represents the P2S VpnClient configurations. |
|  bgpSettings | No | object<br />[BgpSettings object](#BgpSettings)<br /><br />Virtual network gateway's BGP speaker settings |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the VirtualNetworkGateway resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the VirtualNetworkGateway resource Updating/Deleting/Failed |


<a id="VirtualNetworkGatewayIPConfiguration" />
## VirtualNetworkGatewayIPConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[VirtualNetworkGatewayIPConfigurationPropertiesFormat object](#VirtualNetworkGatewayIPConfigurationPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkGatewayIPConfigurationPropertiesFormat" />
## VirtualNetworkGatewayIPConfigurationPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  privateIPAddress | No | string<br /><br />Gets or sets the privateIPAddress of the IP Configuration |
|  privateIPAllocationMethod | No | enum<br />**Static** or **Dynamic**<br /><br />Gets or sets PrivateIP allocation method (Static/Dynamic). |
|  subnet | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the subnet resource |
|  publicIPAddress | No | object<br />[SubResource object](#SubResource)<br /><br />Gets or sets the reference of the PublicIP resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="VirtualNetworkGatewaySku" />
## VirtualNetworkGatewaySku object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | enum<br />**Basic**, **HighPerformance**, **Standard**<br /><br />Gateway sku name -Basic/HighPerformance/Standard. |
|  tier | No | enum<br />**Basic**, **HighPerformance**, **Standard**<br /><br />Gateway sku tier -Basic/HighPerformance/Standard. |
|  capacity | No | integer<br /><br />The capacity |


<a id="VpnClientConfiguration" />
## VpnClientConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  vpnClientAddressPool | No | object<br />[AddressSpace object](#AddressSpace)<br /><br />Gets or sets the reference of the Address space resource which represents Address space for P2S VpnClient. |
|  vpnClientRootCertificates | No | array<br />[VpnClientRootCertificate object](#VpnClientRootCertificate)<br /><br />VpnClientRootCertificate for Virtual network gateway. |
|  vpnClientRevokedCertificates | No | array<br />[VpnClientRevokedCertificate object](#VpnClientRevokedCertificate)<br /><br />VpnClientRevokedCertificate for Virtual network gateway. |


<a id="VpnClientRootCertificate" />
## VpnClientRootCertificate object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[VpnClientRootCertificatePropertiesFormat object](#VpnClientRootCertificatePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="VpnClientRootCertificatePropertiesFormat" />
## VpnClientRootCertificatePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publicCertData | No | string<br /><br />Gets or sets the certificate public data |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the VPN client root certificate resource Updating/Deleting/Failed |


<a id="VpnClientRevokedCertificate" />
## VpnClientRevokedCertificate object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  properties | No | object<br />[VpnClientRevokedCertificatePropertiesFormat object](#VpnClientRevokedCertificatePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="VpnClientRevokedCertificatePropertiesFormat" />
## VpnClientRevokedCertificatePropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  thumbprint | No | string<br /><br />Gets or sets the revoked Vpn client certificate thumbprint |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the VPN client revoked certificate resource Updating/Deleting/Failed |


<a id="LocalNetworkGateway" />
## LocalNetworkGateway object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  location | No | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[LocalNetworkGatewayPropertiesFormat object](#LocalNetworkGatewayPropertiesFormat)<br /> |
|  etag | No | string<br /><br />Gets a unique read-only string that changes whenever the resource is updated |


<a id="VirtualNetworkPropertiesFormat" />
## VirtualNetworkPropertiesFormat object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  addressSpace | No | object<br />[AddressSpace object](#AddressSpace)<br /><br />Gets or sets AddressSpace that contains an array of IP address ranges that can be used by subnets |
|  dhcpOptions | No | object<br />[DhcpOptions object](#DhcpOptions)<br /><br />Gets or sets DHCPOptions that contains an array of DNS servers available to VMs deployed in the virtual network |
|  subnets | No | array<br />[Subnet object](#Subnet)<br /><br />Gets or sets List of subnets in a VirtualNetwork |
|  resourceGuid | No | string<br /><br />Gets or sets resource guid property of the VirtualNetwork resource |
|  provisioningState | No | string<br /><br />Gets or sets Provisioning state of the PublicIP resource Updating/Deleting/Failed |


<a id="DhcpOptions" />
## DhcpOptions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  dnsServers | No | array<br />**string**<br /><br />Gets or sets list of DNS servers IP addresses |


<a id="virtualnetworks_subnets_childResource" />
## virtualnetworks_subnets_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**subnets**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[SubnetPropertiesFormat object](#SubnetPropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="networkSecurityGroups_securityRules_childResource" />
## networkSecurityGroups_securityRules_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**securityRules**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[SecurityRulePropertiesFormat object](#SecurityRulePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |


<a id="routeTables_routes_childResource" />
## routeTables_routes_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**routes**<br /> |
|  apiVersion | Yes | enum<br />**2015-06-15**<br /> |
|  id | No | string<br /><br />Resource Id |
|  properties | Yes | object<br />[RoutePropertiesFormat object](#RoutePropertiesFormat)<br /> |
|  name | No | string<br /><br />Gets name of the resource that is unique within a resource group. This name can be used to access the resource |
|  etag | No | string<br /><br />A unique read-only string that changes whenever the resource is updated |

