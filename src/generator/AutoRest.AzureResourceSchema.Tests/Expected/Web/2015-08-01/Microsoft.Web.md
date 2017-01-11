# Microsoft.Web template schema

Creates a Microsoft.Web resource.

## Schema format

To create a Microsoft.Web, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.Web/certificates",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "friendlyName": "string",
    "subjectName": "string",
    "hostNames": [
      "string"
    ],
    "pfxBlob": "string",
    "siteName": "string",
    "selfLink": "string",
    "issuer": "string",
    "issueDate": "string",
    "expirationDate": "string",
    "password": "string",
    "thumbprint": "string",
    "valid": "boolean",
    "cerBlob": "string",
    "publicKeyHash": "string",
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    }
  }
}
```
```
{
  "type": "Microsoft.Web/csrs",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "distinguishedName": "string",
    "csrString": "string",
    "pfxBlob": "string",
    "password": "string",
    "publicKeyHash": "string",
    "hostingEnvironment": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/hostingEnvironments",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "location": "string",
    "provisioningState": "string",
    "status": "string",
    "vnetName": "string",
    "vnetResourceGroupName": "string",
    "vnetSubnetName": "string",
    "virtualNetwork": {
      "id": "string",
      "name": "string",
      "type": "string",
      "subnet": "string"
    },
    "internalLoadBalancingMode": "string",
    "multiSize": "string",
    "multiRoleCount": "integer",
    "workerPools": [
      {
        "id": "string",
        "name": "string",
        "kind": "string",
        "location": "string",
        "type": "string",
        "tags": {},
        "properties": {
          "workerSizeId": "integer",
          "computeMode": "string",
          "workerSize": "string",
          "workerCount": "integer",
          "instanceNames": [
            "string"
          ]
        },
        "sku": {
          "name": "string",
          "tier": "string",
          "size": "string",
          "family": "string",
          "capacity": "integer"
        }
      }
    ],
    "ipsslAddressCount": "integer",
    "databaseEdition": "string",
    "databaseServiceObjective": "string",
    "upgradeDomains": "integer",
    "subscriptionId": "string",
    "dnsSuffix": "string",
    "lastAction": "string",
    "lastActionResult": "string",
    "allowedMultiSizes": "string",
    "allowedWorkerSizes": "string",
    "maximumNumberOfMachines": "integer",
    "vipMappings": [
      {
        "virtualIP": "string",
        "internalHttpPort": "integer",
        "internalHttpsPort": "integer",
        "inUse": "boolean"
      }
    ],
    "environmentCapacities": [
      {
        "name": "string",
        "availableCapacity": "integer",
        "totalCapacity": "integer",
        "unit": "string",
        "computeMode": "string",
        "workerSize": "string",
        "workerSizeId": "integer",
        "excludeFromCapacityAllocation": "boolean",
        "isApplicableForAllComputeModes": "boolean",
        "siteMode": "string"
      }
    ],
    "networkAccessControlList": [
      {
        "action": "string",
        "description": "string",
        "order": "integer",
        "remoteSubnet": "string"
      }
    ],
    "environmentIsHealthy": "boolean",
    "environmentStatus": "string",
    "resourceGroup": "string",
    "apiManagementAccountId": "string",
    "suspended": "boolean",
    "clusterSettings": [
      {
        "name": "string",
        "value": "string"
      }
    ]
  }
}
```
```
{
  "type": "Microsoft.Web/hostingEnvironments/workerPools",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "workerSizeId": "integer",
    "computeMode": "string",
    "workerSize": "string",
    "workerCount": "integer",
    "instanceNames": [
      "string"
    ]
  }
}
```
```
{
  "type": "Microsoft.Web/managedHostingEnvironments",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "location": "string",
    "provisioningState": "string",
    "status": "string",
    "vnetName": "string",
    "vnetResourceGroupName": "string",
    "vnetSubnetName": "string",
    "virtualNetwork": {
      "id": "string",
      "name": "string",
      "type": "string",
      "subnet": "string"
    },
    "internalLoadBalancingMode": "string",
    "multiSize": "string",
    "multiRoleCount": "integer",
    "workerPools": [
      {
        "id": "string",
        "name": "string",
        "kind": "string",
        "location": "string",
        "type": "string",
        "tags": {},
        "properties": {
          "workerSizeId": "integer",
          "computeMode": "string",
          "workerSize": "string",
          "workerCount": "integer",
          "instanceNames": [
            "string"
          ]
        },
        "sku": {
          "name": "string",
          "tier": "string",
          "size": "string",
          "family": "string",
          "capacity": "integer"
        }
      }
    ],
    "ipsslAddressCount": "integer",
    "databaseEdition": "string",
    "databaseServiceObjective": "string",
    "upgradeDomains": "integer",
    "subscriptionId": "string",
    "dnsSuffix": "string",
    "lastAction": "string",
    "lastActionResult": "string",
    "allowedMultiSizes": "string",
    "allowedWorkerSizes": "string",
    "maximumNumberOfMachines": "integer",
    "vipMappings": [
      {
        "virtualIP": "string",
        "internalHttpPort": "integer",
        "internalHttpsPort": "integer",
        "inUse": "boolean"
      }
    ],
    "environmentCapacities": [
      {
        "name": "string",
        "availableCapacity": "integer",
        "totalCapacity": "integer",
        "unit": "string",
        "computeMode": "string",
        "workerSize": "string",
        "workerSizeId": "integer",
        "excludeFromCapacityAllocation": "boolean",
        "isApplicableForAllComputeModes": "boolean",
        "siteMode": "string"
      }
    ],
    "networkAccessControlList": [
      {
        "action": "string",
        "description": "string",
        "order": "integer",
        "remoteSubnet": "string"
      }
    ],
    "environmentIsHealthy": "boolean",
    "environmentStatus": "string",
    "resourceGroup": "string",
    "apiManagementAccountId": "string",
    "suspended": "boolean",
    "clusterSettings": [
      {
        "name": "string",
        "value": "string"
      }
    ]
  }
}
```
```
{
  "type": "Microsoft.Web/serverfarms",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "workerTierName": "string",
    "adminSiteName": "string",
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    },
    "maximumNumberOfWorkers": "integer",
    "perSiteScaling": "boolean"
  }
}
```
```
{
  "type": "Microsoft.Web/serverfarms/virtualNetworkConnections/routes",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "startAddress": "string",
    "endAddress": "string",
    "routeType": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/serverfarms/virtualNetworkConnections/gateways",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "vnetName": "string",
    "vpnPackageUri": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots/virtualNetworkConnections",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "vnetResourceId": "string",
    "certThumbprint": "string",
    "certBlob": "string",
    "routes": [
      {
        "id": "string",
        "name": "string",
        "kind": "string",
        "location": "string",
        "type": "string",
        "tags": {},
        "properties": {
          "name": "string",
          "startAddress": "string",
          "endAddress": "string",
          "routeType": "string"
        }
      }
    ],
    "resyncRequired": "boolean",
    "dnsServers": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/virtualNetworkConnections",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "vnetResourceId": "string",
    "certThumbprint": "string",
    "certBlob": "string",
    "routes": [
      {
        "id": "string",
        "name": "string",
        "kind": "string",
        "location": "string",
        "type": "string",
        "tags": {},
        "properties": {
          "name": "string",
          "startAddress": "string",
          "endAddress": "string",
          "routeType": "string"
        }
      }
    ],
    "resyncRequired": "boolean",
    "dnsServers": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "enabled": "boolean",
    "hostNameSslStates": [
      {
        "name": "string",
        "sslState": "string",
        "virtualIP": "string",
        "thumbprint": "string",
        "toUpdate": "boolean"
      }
    ],
    "serverFarmId": "string",
    "siteConfig": {
      "id": "string",
      "name": "string",
      "kind": "string",
      "location": "string",
      "type": "string",
      "tags": {},
      "properties": {
        "numberOfWorkers": "integer",
        "defaultDocuments": [
          "string"
        ],
        "netFrameworkVersion": "string",
        "phpVersion": "string",
        "pythonVersion": "string",
        "requestTracingEnabled": "boolean",
        "requestTracingExpirationTime": "string",
        "remoteDebuggingEnabled": "boolean",
        "remoteDebuggingVersion": "string",
        "httpLoggingEnabled": "boolean",
        "logsDirectorySizeLimit": "integer",
        "detailedErrorLoggingEnabled": "boolean",
        "publishingUsername": "string",
        "publishingPassword": "string",
        "appSettings": [
          {
            "name": "string",
            "value": "string"
          }
        ],
        "metadata": [
          {
            "name": "string",
            "value": "string"
          }
        ],
        "connectionStrings": [
          {
            "name": "string",
            "connectionString": "string",
            "type": "string"
          }
        ],
        "handlerMappings": [
          {
            "extension": "string",
            "scriptProcessor": "string",
            "arguments": "string"
          }
        ],
        "documentRoot": "string",
        "scmType": "string",
        "use32BitWorkerProcess": "boolean",
        "webSocketsEnabled": "boolean",
        "alwaysOn": "boolean",
        "javaVersion": "string",
        "javaContainer": "string",
        "javaContainerVersion": "string",
        "managedPipelineMode": "string",
        "virtualApplications": [
          {
            "virtualPath": "string",
            "physicalPath": "string",
            "preloadEnabled": "boolean",
            "virtualDirectories": [
              {
                "virtualPath": "string",
                "physicalPath": "string"
              }
            ]
          }
        ],
        "loadBalancing": "string",
        "experiments": {
          "rampUpRules": [
            {
              "actionHostName": "string",
              "reroutePercentage": "number",
              "changeStep": "number",
              "changeIntervalInMinutes": "integer",
              "minReroutePercentage": "number",
              "maxReroutePercentage": "number",
              "changeDecisionCallbackUrl": "string",
              "name": "string"
            }
          ]
        },
        "limits": {
          "maxPercentageCpu": "number",
          "maxMemoryInMb": "integer",
          "maxDiskSizeInMb": "integer"
        },
        "autoHealEnabled": "boolean",
        "autoHealRules": {
          "triggers": {
            "requests": {
              "count": "integer",
              "timeInterval": "string"
            },
            "privateBytesInKB": "integer",
            "statusCodes": [
              {
                "status": "integer",
                "subStatus": "integer",
                "win32Status": "integer",
                "count": "integer",
                "timeInterval": "string"
              }
            ],
            "slowRequests": {
              "timeTaken": "string",
              "count": "integer",
              "timeInterval": "string"
            }
          },
          "actions": {
            "actionType": "string",
            "customAction": {
              "exe": "string",
              "parameters": "string"
            },
            "minProcessExecutionTime": "string"
          }
        },
        "tracingOptions": "string",
        "vnetName": "string",
        "cors": {
          "allowedOrigins": [
            "string"
          ]
        },
        "apiDefinition": {
          "url": "string"
        },
        "autoSwapSlotName": "string",
        "localMySqlEnabled": "boolean",
        "ipSecurityRestrictions": [
          {
            "ipAddress": "string",
            "subnetMask": "string"
          }
        ]
      }
    },
    "scmSiteAlsoStopped": "boolean",
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    },
    "microService": "string",
    "gatewaySiteName": "string",
    "clientAffinityEnabled": "boolean",
    "clientCertEnabled": "boolean",
    "hostNamesDisabled": "boolean",
    "containerSize": "integer",
    "maxNumberOfWorkers": "integer",
    "cloningInfo": {
      "correlationId": "string",
      "overwrite": "boolean",
      "cloneCustomHostNames": "boolean",
      "cloneSourceControl": "boolean",
      "sourceWebAppId": "string",
      "hostingEnvironment": "string",
      "appSettingsOverrides": {},
      "configureLoadBalancing": "boolean",
      "trafficManagerProfileId": "string",
      "trafficManagerProfileName": "string"
    }
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "enabled": "boolean",
    "hostNameSslStates": [
      {
        "name": "string",
        "sslState": "string",
        "virtualIP": "string",
        "thumbprint": "string",
        "toUpdate": "boolean"
      }
    ],
    "serverFarmId": "string",
    "siteConfig": {
      "id": "string",
      "name": "string",
      "kind": "string",
      "location": "string",
      "type": "string",
      "tags": {},
      "properties": {
        "numberOfWorkers": "integer",
        "defaultDocuments": [
          "string"
        ],
        "netFrameworkVersion": "string",
        "phpVersion": "string",
        "pythonVersion": "string",
        "requestTracingEnabled": "boolean",
        "requestTracingExpirationTime": "string",
        "remoteDebuggingEnabled": "boolean",
        "remoteDebuggingVersion": "string",
        "httpLoggingEnabled": "boolean",
        "logsDirectorySizeLimit": "integer",
        "detailedErrorLoggingEnabled": "boolean",
        "publishingUsername": "string",
        "publishingPassword": "string",
        "appSettings": [
          {
            "name": "string",
            "value": "string"
          }
        ],
        "metadata": [
          {
            "name": "string",
            "value": "string"
          }
        ],
        "connectionStrings": [
          {
            "name": "string",
            "connectionString": "string",
            "type": "string"
          }
        ],
        "handlerMappings": [
          {
            "extension": "string",
            "scriptProcessor": "string",
            "arguments": "string"
          }
        ],
        "documentRoot": "string",
        "scmType": "string",
        "use32BitWorkerProcess": "boolean",
        "webSocketsEnabled": "boolean",
        "alwaysOn": "boolean",
        "javaVersion": "string",
        "javaContainer": "string",
        "javaContainerVersion": "string",
        "managedPipelineMode": "string",
        "virtualApplications": [
          {
            "virtualPath": "string",
            "physicalPath": "string",
            "preloadEnabled": "boolean",
            "virtualDirectories": [
              {
                "virtualPath": "string",
                "physicalPath": "string"
              }
            ]
          }
        ],
        "loadBalancing": "string",
        "experiments": {
          "rampUpRules": [
            {
              "actionHostName": "string",
              "reroutePercentage": "number",
              "changeStep": "number",
              "changeIntervalInMinutes": "integer",
              "minReroutePercentage": "number",
              "maxReroutePercentage": "number",
              "changeDecisionCallbackUrl": "string",
              "name": "string"
            }
          ]
        },
        "limits": {
          "maxPercentageCpu": "number",
          "maxMemoryInMb": "integer",
          "maxDiskSizeInMb": "integer"
        },
        "autoHealEnabled": "boolean",
        "autoHealRules": {
          "triggers": {
            "requests": {
              "count": "integer",
              "timeInterval": "string"
            },
            "privateBytesInKB": "integer",
            "statusCodes": [
              {
                "status": "integer",
                "subStatus": "integer",
                "win32Status": "integer",
                "count": "integer",
                "timeInterval": "string"
              }
            ],
            "slowRequests": {
              "timeTaken": "string",
              "count": "integer",
              "timeInterval": "string"
            }
          },
          "actions": {
            "actionType": "string",
            "customAction": {
              "exe": "string",
              "parameters": "string"
            },
            "minProcessExecutionTime": "string"
          }
        },
        "tracingOptions": "string",
        "vnetName": "string",
        "cors": {
          "allowedOrigins": [
            "string"
          ]
        },
        "apiDefinition": {
          "url": "string"
        },
        "autoSwapSlotName": "string",
        "localMySqlEnabled": "boolean",
        "ipSecurityRestrictions": [
          {
            "ipAddress": "string",
            "subnetMask": "string"
          }
        ]
      }
    },
    "scmSiteAlsoStopped": "boolean",
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    },
    "microService": "string",
    "gatewaySiteName": "string",
    "clientAffinityEnabled": "boolean",
    "clientCertEnabled": "boolean",
    "hostNamesDisabled": "boolean",
    "containerSize": "integer",
    "maxNumberOfWorkers": "integer",
    "cloningInfo": {
      "correlationId": "string",
      "overwrite": "boolean",
      "cloneCustomHostNames": "boolean",
      "cloneSourceControl": "boolean",
      "sourceWebAppId": "string",
      "hostingEnvironment": "string",
      "appSettingsOverrides": {},
      "configureLoadBalancing": "boolean",
      "trafficManagerProfileId": "string",
      "trafficManagerProfileName": "string"
    }
  }
}
```
```
{
  "type": "Microsoft.Web/sites/instances/deployments",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "id": "string",
    "status": "integer",
    "message": "string",
    "author": "string",
    "deployer": "string",
    "author_email": "string",
    "start_time": "string",
    "end_time": "string",
    "active": "boolean",
    "details": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/deployments",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "id": "string",
    "status": "integer",
    "message": "string",
    "author": "string",
    "deployer": "string",
    "author_email": "string",
    "start_time": "string",
    "end_time": "string",
    "active": "boolean",
    "details": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots/deployments",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "id": "string",
    "status": "integer",
    "message": "string",
    "author": "string",
    "deployer": "string",
    "author_email": "string",
    "start_time": "string",
    "end_time": "string",
    "active": "boolean",
    "details": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots/instances/deployments",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "id": "string",
    "status": "integer",
    "message": "string",
    "author": "string",
    "deployer": "string",
    "author_email": "string",
    "start_time": "string",
    "end_time": "string",
    "active": "boolean",
    "details": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/hostNameBindings",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "siteName": "string",
    "domainId": "string",
    "azureResourceName": "string",
    "azureResourceType": "string",
    "customHostNameDnsRecordType": "string",
    "hostNameType": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots/hostNameBindings",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "name": "string",
    "siteName": "string",
    "domainId": "string",
    "azureResourceName": "string",
    "azureResourceType": "string",
    "customHostNameDnsRecordType": "string",
    "hostNameType": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/premieraddons",
  "apiVersion": "2015-08-01",
  "properties": {}
}
```
```
{
  "type": "Microsoft.Web/sites/slots/premieraddons",
  "apiVersion": "2015-08-01",
  "properties": {}
}
```
```
{
  "type": "Microsoft.Web/sites/hybridconnection",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "entityName": "string",
    "entityConnectionString": "string",
    "resourceType": "string",
    "resourceConnectionString": "string",
    "hostname": "string",
    "port": "integer",
    "biztalkUri": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots/hybridconnection",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "entityName": "string",
    "entityConnectionString": "string",
    "resourceType": "string",
    "resourceConnectionString": "string",
    "hostname": "string",
    "port": "integer",
    "biztalkUri": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/slots/virtualNetworkConnections/gateways",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "vnetName": "string",
    "vpnPackageUri": "string"
  }
}
```
```
{
  "type": "Microsoft.Web/sites/virtualNetworkConnections/gateways",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "vnetName": "string",
    "vpnPackageUri": "string"
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="certificates" />
## certificates object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/certificates**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Certificate_properties object](#Certificate_properties)<br /> |


<a id="csrs" />
## csrs object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/csrs**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Csr_properties object](#Csr_properties)<br /> |


<a id="hostingEnvironments" />
## hostingEnvironments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/hostingEnvironments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[HostingEnvironment_properties object](#HostingEnvironment_properties)<br /> |
|  resources | No | array<br />[workerPools object](#workerPools)<br /> |


<a id="hostingEnvironments_workerPools" />
## hostingEnvironments_workerPools object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/hostingEnvironments/workerPools**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[WorkerPool_properties object](#WorkerPool_properties)<br /> |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /> |


<a id="managedHostingEnvironments" />
## managedHostingEnvironments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/managedHostingEnvironments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[HostingEnvironment_properties object](#HostingEnvironment_properties)<br /> |


<a id="serverfarms" />
## serverfarms object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/serverfarms**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[ServerFarmWithRichSku_properties object](#ServerFarmWithRichSku_properties)<br /> |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /> |


<a id="serverfarms_virtualNetworkConnections_routes" />
## serverfarms_virtualNetworkConnections_routes object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/serverfarms/virtualNetworkConnections/routes**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetRoute_properties object](#VnetRoute_properties)<br /> |


<a id="serverfarms_virtualNetworkConnections_gateways" />
## serverfarms_virtualNetworkConnections_gateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/serverfarms/virtualNetworkConnections/gateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetGateway_properties object](#VnetGateway_properties)<br /> |


<a id="sites_slots_virtualNetworkConnections" />
## sites_slots_virtualNetworkConnections object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/virtualNetworkConnections**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetInfo_properties object](#VnetInfo_properties)<br /> |
|  resources | No | array<br />[gateways object](#gateways)<br /> |


<a id="sites_virtualNetworkConnections" />
## sites_virtualNetworkConnections object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/virtualNetworkConnections**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetInfo_properties object](#VnetInfo_properties)<br /> |
|  resources | No | array<br />[gateways object](#gateways)<br /> |


<a id="sites" />
## sites object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Site_properties object](#Site_properties)<br /> |
|  resources | No | array<br />[hybridconnection object](#hybridconnection)<br />[premieraddons object](#premieraddons)<br />[hostNameBindings object](#hostNameBindings)<br />[deployments object](#deployments)<br />[slots object](#slots)<br />[virtualNetworkConnections object](#virtualNetworkConnections)<br /> |


<a id="sites_slots" />
## sites_slots object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Site_properties object](#Site_properties)<br /> |
|  resources | No | array<br />[hybridconnection object](#hybridconnection)<br />[premieraddons object](#premieraddons)<br />[hostNameBindings object](#hostNameBindings)<br />[deployments object](#deployments)<br />[virtualNetworkConnections object](#virtualNetworkConnections)<br /> |


<a id="sites_instances_deployments" />
## sites_instances_deployments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/instances/deployments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Deployment_properties object](#Deployment_properties)<br /> |


<a id="sites_deployments" />
## sites_deployments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/deployments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Deployment_properties object](#Deployment_properties)<br /> |


<a id="sites_slots_deployments" />
## sites_slots_deployments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/deployments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Deployment_properties object](#Deployment_properties)<br /> |


<a id="sites_slots_instances_deployments" />
## sites_slots_instances_deployments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/instances/deployments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Deployment_properties object](#Deployment_properties)<br /> |


<a id="sites_hostNameBindings" />
## sites_hostNameBindings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/hostNameBindings**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[HostNameBinding_properties object](#HostNameBinding_properties)<br /> |


<a id="sites_slots_hostNameBindings" />
## sites_slots_hostNameBindings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/hostNameBindings**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[HostNameBinding_properties object](#HostNameBinding_properties)<br /> |


<a id="sites_premieraddons" />
## sites_premieraddons object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/premieraddons**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | No | object<br /><br />Tags associated with resource |
|  plan | No | object<br />[ArmPlan object](#ArmPlan)<br /><br />Azure resource manager plan |
|  properties | Yes | object<br /><br />Resource specific properties |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /><br />Sku description of the resource |


<a id="sites_slots_premieraddons" />
## sites_slots_premieraddons object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/premieraddons**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | No | object<br /><br />Tags associated with resource |
|  plan | No | object<br />[ArmPlan object](#ArmPlan)<br /><br />Azure resource manager plan |
|  properties | Yes | object<br /><br />Resource specific properties |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /><br />Sku description of the resource |


<a id="sites_hybridconnection" />
## sites_hybridconnection object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/hybridconnection**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties)<br /> |


<a id="sites_slots_hybridconnection" />
## sites_slots_hybridconnection object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/hybridconnection**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties)<br /> |


<a id="sites_slots_virtualNetworkConnections_gateways" />
## sites_slots_virtualNetworkConnections_gateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/slots/virtualNetworkConnections/gateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetGateway_properties object](#VnetGateway_properties)<br /> |


<a id="sites_virtualNetworkConnections_gateways" />
## sites_virtualNetworkConnections_gateways object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.Web/sites/virtualNetworkConnections/gateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetGateway_properties object](#VnetGateway_properties)<br /> |


<a id="Certificate_properties" />
## Certificate_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  friendlyName | No | string<br /><br />Friendly name of the certificate |
|  subjectName | No | string<br /><br />Subject name of the certificate |
|  hostNames | No | array<br />**string**<br /><br />Host names the certificate applies to |
|  pfxBlob | No | string<br /><br />Pfx blob |
|  siteName | No | string<br /><br />App name |
|  selfLink | No | string<br /><br />Self link |
|  issuer | No | string<br /><br />Certificate issuer |
|  issueDate | No | string<br /><br />Certificate issue Date |
|  expirationDate | No | string<br /><br />Certificate expriration date |
|  password | No | string<br /><br />Certificate password |
|  thumbprint | No | string<br /><br />Certificate thumbprint |
|  valid | No | boolean<br /><br />Is the certificate valid? |
|  cerBlob | No | string<br /><br />Raw bytes of .cer file |
|  publicKeyHash | No | string<br /><br />Public key hash |
|  hostingEnvironmentProfile | No | object<br />[HostingEnvironmentProfile object](#HostingEnvironmentProfile)<br /><br />Specification for the hosting environment (App Service Environment) to use for the certificate |


<a id="HostingEnvironmentProfile" />
## HostingEnvironmentProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource id of the hostingEnvironment (App Service Environment) |
|  name | No | string<br /><br />Name of the hostingEnvironment (App Service Environment) (read only) |
|  type | No | string<br /><br />Resource type of the hostingEnvironment (App Service Environment) (read only) |


<a id="Csr_properties" />
## Csr_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name used to locate CSR object |
|  distinguishedName | No | string<br /><br />Distinguished name of certificate to be created |
|  csrString | No | string<br /><br />Actual CSR string created |
|  pfxBlob | No | string<br /><br />PFX certifcate of created certificate |
|  password | No | string<br /><br />PFX password |
|  publicKeyHash | No | string<br /><br />Hash of the certificates public key |
|  hostingEnvironment | No | string<br /><br />Hosting environment |


<a id="HostingEnvironment_properties" />
## HostingEnvironment_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name of the hostingEnvironment (App Service Environment) |
|  location | No | string<br /><br />Location of the hostingEnvironment (App Service Environment), e.g. "West US" |
|  provisioningState | No | enum<br />**Succeeded**, **Failed**, **Canceled**, **InProgress**, **Deleting**<br /><br />Provisioning state of the hostingEnvironment (App Service Environment). |
|  status | No | enum<br />**Preparing**, **Ready**, **Scaling**, **Deleting**<br /><br />Current status of the hostingEnvironment (App Service Environment). |
|  vnetName | No | string<br /><br />Name of the hostingEnvironment's (App Service Environment) virtual network |
|  vnetResourceGroupName | No | string<br /><br />Resource group of the hostingEnvironment's (App Service Environment) virtual network |
|  vnetSubnetName | No | string<br /><br />Subnet of the hostingEnvironment's (App Service Environment) virtual network |
|  virtualNetwork | No | object<br />[VirtualNetworkProfile object](#VirtualNetworkProfile)<br /><br />Description of the hostingEnvironment's (App Service Environment) virtual network |
|  internalLoadBalancingMode | No | enum<br />**None**, **Web**, **Publishing**<br /><br />Specifies which endpoints to serve internally in the hostingEnvironment's (App Service Environment) VNET. |
|  multiSize | No | string<br /><br />Front-end VM size, e.g. "Medium", "Large" |
|  multiRoleCount | No | integer<br /><br />Number of front-end instances |
|  workerPools | No | array<br />[WorkerPool object](#WorkerPool)<br /><br />Description of worker pools with worker size ids, VM sizes, and number of workers in each pool |
|  ipsslAddressCount | No | integer<br /><br />Number of IP SSL addresses reserved for this hostingEnvironment (App Service Environment) |
|  databaseEdition | No | string<br /><br />Edition of the metadata database for the hostingEnvironment (App Service Environment) e.g. "Standard" |
|  databaseServiceObjective | No | string<br /><br />Service objective of the metadata database for the hostingEnvironment (App Service Environment) e.g. "S0" |
|  upgradeDomains | No | integer<br /><br />Number of upgrade domains of this hostingEnvironment (App Service Environment) |
|  subscriptionId | No | string<br /><br />Subscription of the hostingEnvironment (App Service Environment) |
|  dnsSuffix | No | string<br /><br />DNS suffix of the hostingEnvironment (App Service Environment) |
|  lastAction | No | string<br /><br />Last deployment action on this hostingEnvironment (App Service Environment) |
|  lastActionResult | No | string<br /><br />Result of the last deployment action on this hostingEnvironment (App Service Environment) |
|  allowedMultiSizes | No | string<br /><br />List of comma separated strings describing which VM sizes are allowed for front-ends |
|  allowedWorkerSizes | No | string<br /><br />List of comma separated strings describing which VM sizes are allowed for workers |
|  maximumNumberOfMachines | No | integer<br /><br />Maximum number of VMs in this hostingEnvironment (App Service Environment) |
|  vipMappings | No | array<br />[VirtualIPMapping object](#VirtualIPMapping)<br /><br />Description of IP SSL mapping for this hostingEnvironment (App Service Environment) |
|  environmentCapacities | No | array<br />[StampCapacity object](#StampCapacity)<br /><br />Current total, used, and available worker capacities |
|  networkAccessControlList | No | array<br />[NetworkAccessControlEntry object](#NetworkAccessControlEntry)<br /><br />Access control list for controlling traffic to the hostingEnvironment (App Service Environment) |
|  environmentIsHealthy | No | boolean<br /><br />True/false indicating whether the hostingEnvironment (App Service Environment) is healthy |
|  environmentStatus | No | string<br /><br />Detailed message about with results of the last check of the hostingEnvironment (App Service Environment) |
|  resourceGroup | No | string<br /><br />Resource group of the hostingEnvironment (App Service Environment) |
|  apiManagementAccountId | No | string<br /><br />Api Management Account associated with this Hosting Environment |
|  suspended | No | boolean<br /><br />True/false indicating whether the hostingEnvironment is suspended. The environment can be suspended e.g. when the management endpoint is no longer available
            (most likely because NSG blocked the incoming traffic) |
|  clusterSettings | No | array<br />[NameValuePair object](#NameValuePair)<br /><br />Custom settings for changing the behavior of the hosting environment |


<a id="VirtualNetworkProfile" />
## VirtualNetworkProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource id of the virtual network |
|  name | No | string<br /><br />Name of the virtual network (read-only) |
|  type | No | string<br /><br />Resource type of the virtual network (read-only) |
|  subnet | No | string<br /><br />Subnet within the virtual network |


<a id="WorkerPool" />
## WorkerPool object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  type | No | string<br /><br />Resource type |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[WorkerPool_properties object](#WorkerPool_properties)<br /> |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /> |


<a id="WorkerPool_properties" />
## WorkerPool_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  workerSizeId | No | integer<br /><br />Worker size id for referencing this worker pool |
|  computeMode | No | enum<br />**Shared**, **Dedicated**, **Dynamic**<br /><br />Shared or dedicated web app hosting. |
|  workerSize | No | string<br /><br />VM size of the worker pool instances |
|  workerCount | No | integer<br /><br />Number of instances in the worker pool |
|  instanceNames | No | array<br />**string**<br /><br />Names of all instances in the worker pool (read only) |


<a id="SkuDescription" />
## SkuDescription object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name of the resource sku |
|  tier | No | string<br /><br />Service Tier of the resource sku |
|  size | No | string<br /><br />Size specifier of the resource sku |
|  family | No | string<br /><br />Family code of the resource sku |
|  capacity | No | integer<br /><br />Current number of instances assigned to the resource |


<a id="VirtualIPMapping" />
## VirtualIPMapping object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  virtualIP | No | string<br /><br />Virtual IP address |
|  internalHttpPort | No | integer<br /><br />Internal HTTP port |
|  internalHttpsPort | No | integer<br /><br />Internal HTTPS port |
|  inUse | No | boolean<br /><br />Is VIP mapping in use |


<a id="StampCapacity" />
## StampCapacity object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name of the stamp |
|  availableCapacity | No | integer<br /><br />Available capacity (# of machines, bytes of storage etc...) |
|  totalCapacity | No | integer<br /><br />Total capacity (# of machines, bytes of storage etc...) |
|  unit | No | string<br /><br />Name of the unit |
|  computeMode | No | enum<br />**Shared**, **Dedicated**, **Dynamic**<br /><br />Shared/Dedicated workers. |
|  workerSize | No | enum<br />**Default**, **Small**, **Medium**, **Large**<br /><br />Size of the machines. |
|  workerSizeId | No | integer<br /><br />Size Id of machines:
            0 - Small
            1 - Medium
            2 - Large |
|  excludeFromCapacityAllocation | No | boolean<br /><br />If true it includes basic sites
            Basic sites are not used for capacity allocation. |
|  isApplicableForAllComputeModes | No | boolean<br /><br />Is capacity applicable for all sites? |
|  siteMode | No | string<br /><br />Shared or Dedicated |


<a id="NetworkAccessControlEntry" />
## NetworkAccessControlEntry object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  action | No | enum<br />**Permit** or **Deny**<br /> |
|  description | No | string<br /> |
|  order | No | integer<br /> |
|  remoteSubnet | No | string<br /> |


<a id="NameValuePair" />
## NameValuePair object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Pair name |
|  value | No | string<br /><br />Pair value |


<a id="ServerFarmWithRichSku_properties" />
## ServerFarmWithRichSku_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name for the App Service Plan |
|  workerTierName | No | string<br /><br />Target worker tier assigned to the App Service Plan |
|  adminSiteName | No | string<br /><br />App Service Plan administration site |
|  hostingEnvironmentProfile | No | object<br />[HostingEnvironmentProfile object](#HostingEnvironmentProfile)<br /><br />Specification for the hosting environment (App Service Environment) to use for the App Service Plan |
|  maximumNumberOfWorkers | No | integer<br /><br />Maximum number of instances that can be assigned to this App Service Plan |
|  perSiteScaling | No | boolean<br /><br />If True apps assigned to this App Service Plan can be scaled independently
            If False apps assigned to this App Service Plan will scale to all instances of the plan |


<a id="VnetRoute_properties" />
## VnetRoute_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />The name of this route. This is only returned by the server and does not need to be set by the client. |
|  startAddress | No | string<br /><br />The starting address for this route. This may also include a CIDR notation, in which case the end address must not be specified. |
|  endAddress | No | string<br /><br />The ending address for this route. If the start address is specified in CIDR notation, this must be omitted. |
|  routeType | No | string<br /><br />The type of route this is:
            DEFAULT - By default, every web app has routes to the local address ranges specified by RFC1918
            INHERITED - Routes inherited from the real Virtual Network routes
            STATIC - Static route set on the web app only

            These values will be used for syncing a Web App's routes with those from a Virtual Network. This operation will clear all DEFAULT and INHERITED routes and replace them
            with new INHERITED routes. |


<a id="VnetGateway_properties" />
## VnetGateway_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  vnetName | No | string<br /><br />The VNET name. |
|  vpnPackageUri | No | string<br /><br />The URI where the Vpn package can be downloaded |


<a id="VnetInfo_properties" />
## VnetInfo_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  vnetResourceId | No | string<br /><br />The vnet resource id |
|  certThumbprint | No | string<br /><br />The client certificate thumbprint |
|  certBlob | No | string<br /><br />A certificate file (.cer) blob containing the public key of the private key used to authenticate a
            Point-To-Site VPN connection. |
|  routes | No | array<br />[VnetRoute object](#VnetRoute)<br /><br />The routes that this virtual network connection uses. |
|  resyncRequired | No | boolean<br /><br />Flag to determine if a resync is required |
|  dnsServers | No | string<br /><br />Dns servers to be used by this VNET. This should be a comma-separated list of IP addresses. |


<a id="VnetRoute" />
## VnetRoute object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  type | No | string<br /><br />Resource type |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[VnetRoute_properties object](#VnetRoute_properties)<br /> |


<a id="Site_properties" />
## Site_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name of web app |
|  enabled | No | boolean<br /><br />True if the site is enabled; otherwise, false. Setting this  value to false disables the site (takes the site off line). |
|  hostNameSslStates | No | array<br />[HostNameSslState object](#HostNameSslState)<br /><br />Hostname SSL states are  used to manage the SSL bindings for site's hostnames. |
|  serverFarmId | No | string<br /> |
|  siteConfig | No | object<br />[SiteConfig object](#SiteConfig)<br /><br />Configuration of web app |
|  scmSiteAlsoStopped | No | boolean<br /><br />If set indicates whether to stop SCM (KUDU) site when the web app is stopped. Default is false. |
|  hostingEnvironmentProfile | No | object<br />[HostingEnvironmentProfile object](#HostingEnvironmentProfile)<br /><br />Specification for the hosting environment (App Service Environment) to use for the web app |
|  microService | No | string<br /> |
|  gatewaySiteName | No | string<br /><br />Name of gateway app associated with web app |
|  clientAffinityEnabled | No | boolean<br /><br />Specifies if the client affinity is enabled when load balancing http request for multiple instances of the web app |
|  clientCertEnabled | No | boolean<br /><br />Specifies if the client certificate is enabled for the web app |
|  hostNamesDisabled | No | boolean<br /><br />Specifies if the public hostnames are disabled the web app.
            If set to true the app is only accessible via API Management process |
|  containerSize | No | integer<br /><br />Size of a function container |
|  maxNumberOfWorkers | No | integer<br /><br />Maximum number of workers
            This only applies to function container |
|  cloningInfo | No | object<br />[CloningInfo object](#CloningInfo)<br /><br />This is only valid for web app creation. If specified, web app is cloned from
            a source web app |


<a id="HostNameSslState" />
## HostNameSslState object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Host name |
|  sslState | Yes | enum<br />**Disabled**, **SniEnabled**, **IpBasedEnabled**<br /><br />SSL type. |
|  virtualIP | No | string<br /><br />Virtual IP address assigned to the host name if IP based SSL is enabled |
|  thumbprint | No | string<br /><br />SSL cert thumbprint |
|  toUpdate | No | boolean<br /><br />Set this flag to update existing host name |


<a id="SiteConfig" />
## SiteConfig object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  type | No | string<br /><br />Resource type |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[SiteConfig_properties object](#SiteConfig_properties)<br /> |


<a id="SiteConfig_properties" />
## SiteConfig_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  numberOfWorkers | No | integer<br /><br />Number of workers |
|  defaultDocuments | No | array<br />**string**<br /><br />Default documents |
|  netFrameworkVersion | No | string<br /><br />Net Framework Version |
|  phpVersion | No | string<br /><br />Version of PHP |
|  pythonVersion | No | string<br /><br />Version of Python |
|  requestTracingEnabled | No | boolean<br /><br />Enable request tracing |
|  requestTracingExpirationTime | No | string<br /><br />Request tracing expiration time |
|  remoteDebuggingEnabled | No | boolean<br /><br />Remote Debugging Enabled |
|  remoteDebuggingVersion | No | string<br /><br />Remote Debugging Version |
|  httpLoggingEnabled | No | boolean<br /><br />HTTP logging Enabled |
|  logsDirectorySizeLimit | No | integer<br /><br />HTTP Logs Directory size limit |
|  detailedErrorLoggingEnabled | No | boolean<br /><br />Detailed error logging enabled |
|  publishingUsername | No | string<br /><br />Publishing user name |
|  publishingPassword | No | string<br /><br />Publishing password |
|  appSettings | No | array<br />[NameValuePair object](#NameValuePair)<br /><br />Application Settings |
|  metadata | No | array<br />[NameValuePair object](#NameValuePair)<br /><br />Site Metadata |
|  connectionStrings | No | array<br />[ConnStringInfo object](#ConnStringInfo)<br /><br />Connection strings |
|  handlerMappings | No | array<br />[HandlerMapping object](#HandlerMapping)<br /><br />Handler mappings |
|  documentRoot | No | string<br /><br />Document root |
|  scmType | No | string<br /><br />SCM type |
|  use32BitWorkerProcess | No | boolean<br /><br />Use 32 bit worker process |
|  webSocketsEnabled | No | boolean<br /><br />Web socket enabled. |
|  alwaysOn | No | boolean<br /><br />Always On |
|  javaVersion | No | string<br /><br />Java version |
|  javaContainer | No | string<br /><br />Java container |
|  javaContainerVersion | No | string<br /><br />Java container version |
|  managedPipelineMode | No | enum<br />**Integrated** or **Classic**<br /><br />Managed pipeline mode. |
|  virtualApplications | No | array<br />[VirtualApplication object](#VirtualApplication)<br /><br />Virtual applications |
|  loadBalancing | No | enum<br />**WeightedRoundRobin**, **LeastRequests**, **LeastResponseTime**, **WeightedTotalTraffic**, **RequestHash**<br /><br />Site load balancing. |
|  experiments | No | object<br />[Experiments object](#Experiments)<br /><br />This is work around for polymophic types |
|  limits | No | object<br />[SiteLimits object](#SiteLimits)<br /><br />Site limits |
|  autoHealEnabled | No | boolean<br /><br />Auto heal enabled |
|  autoHealRules | No | object<br />[AutoHealRules object](#AutoHealRules)<br /><br />Auto heal rules |
|  tracingOptions | No | string<br /><br />Tracing options |
|  vnetName | No | string<br /><br />Vnet name |
|  cors | No | object<br />[CorsSettings object](#CorsSettings)<br /><br />Cross-Origin Resource Sharing (CORS) settings. |
|  apiDefinition | No | object<br />[ApiDefinitionInfo object](#ApiDefinitionInfo)<br /><br />Information about the formal API definition for the web app. |
|  autoSwapSlotName | No | string<br /><br />Auto swap slot name |
|  localMySqlEnabled | No | boolean<br /><br />Local mysql enabled |
|  ipSecurityRestrictions | No | array<br />[IpSecurityRestriction object](#IpSecurityRestriction)<br /><br />Ip Security restrictions |


<a id="ConnStringInfo" />
## ConnStringInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name of connection string |
|  connectionString | No | string<br /><br />Connection string value |
|  type | Yes | enum<br />**MySql**, **SQLServer**, **SQLAzure**, **Custom**<br /><br />Type of database. |


<a id="HandlerMapping" />
## HandlerMapping object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  extension | No | string<br /><br />Requests with this extension will be handled using the specified FastCGI application. |
|  scriptProcessor | No | string<br /><br />The absolute path to the FastCGI application. |
|  arguments | No | string<br /><br />Command-line arguments to be passed to the script processor. |


<a id="VirtualApplication" />
## VirtualApplication object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  virtualPath | No | string<br /> |
|  physicalPath | No | string<br /> |
|  preloadEnabled | No | boolean<br /> |
|  virtualDirectories | No | array<br />[VirtualDirectory object](#VirtualDirectory)<br /> |


<a id="VirtualDirectory" />
## VirtualDirectory object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  virtualPath | No | string<br /> |
|  physicalPath | No | string<br /> |


<a id="Experiments" />
## Experiments object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  rampUpRules | No | array<br />[RampUpRule object](#RampUpRule)<br /><br />List of {Microsoft.Web.Hosting.Administration.RampUpRule} objects. |


<a id="RampUpRule" />
## RampUpRule object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  actionHostName | No | string<br /><br />Hostname of a slot to which the traffic will be redirected if decided to. E.g. mysite-stage.azurewebsites.net |
|  reroutePercentage | No | number<br /><br />Percentage of the traffic which will be redirected to {Microsoft.Web.Hosting.Administration.RampUpRule.ActionHostName} |
|  changeStep | No | number<br /><br />[Optional] In auto ramp up scenario this is the step to to add/remove from {Microsoft.Web.Hosting.Administration.RampUpRule.ReroutePercentage} until it reaches
            {Microsoft.Web.Hosting.Administration.RampUpRule.MinReroutePercentage} or {Microsoft.Web.Hosting.Administration.RampUpRule.MaxReroutePercentage}. Site metrics are checked every N minutes specificed in {Microsoft.Web.Hosting.Administration.RampUpRule.ChangeIntervalInMinutes}.
            Custom decision algorithm can be provided in TiPCallback site extension which Url can be specified in {Microsoft.Web.Hosting.Administration.RampUpRule.ChangeDecisionCallbackUrl} |
|  changeIntervalInMinutes | No | integer<br /><br />[Optional] Specifies interval in mimuntes to reevaluate ReroutePercentage |
|  minReroutePercentage | No | number<br /><br />[Optional] Specifies lower boundary above which ReroutePercentage will stay. |
|  maxReroutePercentage | No | number<br /><br />[Optional] Specifies upper boundary below which ReroutePercentage will stay. |
|  changeDecisionCallbackUrl | No | string<br /><br />Custom decision algorithm can be provided in TiPCallback site extension which Url can be specified. See TiPCallback site extension for the scaffold and contracts.
            https://www.siteextensions.net/packages/TiPCallback/ |
|  name | No | string<br /><br />Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment. |


<a id="SiteLimits" />
## SiteLimits object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  maxPercentageCpu | No | number<br /><br />Maximum allowed CPU usage percentage |
|  maxMemoryInMb | No | integer<br /><br />Maximum allowed memory usage in MB |
|  maxDiskSizeInMb | No | integer<br /><br />Maximum allowed disk size usage in MB |


<a id="AutoHealRules" />
## AutoHealRules object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  triggers | No | object<br />[AutoHealTriggers object](#AutoHealTriggers)<br /><br />Triggers - Conditions that describe when to execute the auto-heal actions |
|  actions | No | object<br />[AutoHealActions object](#AutoHealActions)<br /><br />Actions - Actions to be executed when a rule is triggered |


<a id="AutoHealTriggers" />
## AutoHealTriggers object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  requests | No | object<br />[RequestsBasedTrigger object](#RequestsBasedTrigger)<br /><br />Requests - Defines a rule based on total requests |
|  privateBytesInKB | No | integer<br /><br />PrivateBytesInKB - Defines a rule based on private bytes |
|  statusCodes | No | array<br />[StatusCodesBasedTrigger object](#StatusCodesBasedTrigger)<br /><br />StatusCodes - Defines a rule based on status codes |
|  slowRequests | No | object<br />[SlowRequestsBasedTrigger object](#SlowRequestsBasedTrigger)<br /><br />SlowRequests - Defines a rule based on request execution time |


<a id="RequestsBasedTrigger" />
## RequestsBasedTrigger object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  count | No | integer<br /><br />Count |
|  timeInterval | No | string<br /><br />TimeInterval |


<a id="StatusCodesBasedTrigger" />
## StatusCodesBasedTrigger object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  status | No | integer<br /><br />HTTP status code |
|  subStatus | No | integer<br /><br />SubStatus |
|  win32Status | No | integer<br /><br />Win32 error code |
|  count | No | integer<br /><br />Count |
|  timeInterval | No | string<br /><br />TimeInterval |


<a id="SlowRequestsBasedTrigger" />
## SlowRequestsBasedTrigger object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  timeTaken | No | string<br /><br />TimeTaken |
|  count | No | integer<br /><br />Count |
|  timeInterval | No | string<br /><br />TimeInterval |


<a id="AutoHealActions" />
## AutoHealActions object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  actionType | Yes | enum<br />**Recycle**, **LogEvent**, **CustomAction**<br /><br />ActionType - predefined action to be taken. |
|  customAction | No | object<br />[AutoHealCustomAction object](#AutoHealCustomAction)<br /><br />CustomAction - custom action to be taken |
|  minProcessExecutionTime | No | string<br /><br />MinProcessExecutionTime - minimum time the process must execute
            before taking the action |


<a id="AutoHealCustomAction" />
## AutoHealCustomAction object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  exe | No | string<br /><br />Executable to be run |
|  parameters | No | string<br /><br />Parameters for the executable |


<a id="CorsSettings" />
## CorsSettings object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  allowedOrigins | No | array<br />**string**<br /><br />Gets or sets the list of origins that should be allowed to make cross-origin
            calls (for example: http://example.com:12345). Use "*" to allow all. |


<a id="ApiDefinitionInfo" />
## ApiDefinitionInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  url | No | string<br /><br />The URL of the API definition. |


<a id="IpSecurityRestriction" />
## IpSecurityRestriction object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  ipAddress | No | string<br /><br />IP address the security restriction is valid for |
|  subnetMask | No | string<br /><br />Subnet mask for the range of IP addresses the restriction is valid for |


<a id="CloningInfo" />
## CloningInfo object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  correlationId | No | string<br /><br />Correlation Id of cloning operation. This id ties multiple cloning operations
            together to use the same snapshot |
|  overwrite | No | boolean<br /><br />Overwrite destination web app |
|  cloneCustomHostNames | No | boolean<br /><br />If true, clone custom hostnames from source web app |
|  cloneSourceControl | No | boolean<br /><br />Clone source control from source web app |
|  sourceWebAppId | No | string<br /><br />ARM resource id of the source web app. Web app resource id is of the form
            /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName} for production slots and
            /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slotName} for other slots |
|  hostingEnvironment | No | string<br /><br />Hosting environment |
|  appSettingsOverrides | No | object<br /><br />Application settings overrides for cloned web app. If specified these settings will override the settings cloned
            from source web app. If not specified, application settings from source web app are retained. |
|  configureLoadBalancing | No | boolean<br /><br />If specified configure load balancing for source and clone site |
|  trafficManagerProfileId | No | string<br /><br />ARM resource id of the traffic manager profile to use if it exists. Traffic manager resource id is of the form
            /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficManagerProfiles/{profileName} |
|  trafficManagerProfileName | No | string<br /><br />Name of traffic manager profile to create. This is only needed if traffic manager profile does not already exist |


<a id="Deployment_properties" />
## Deployment_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Id |
|  status | No | integer<br /><br />Status |
|  message | No | string<br /><br />Message |
|  author | No | string<br /><br />Author |
|  deployer | No | string<br /><br />Deployer |
|  author_email | No | string<br /><br />AuthorEmail |
|  start_time | No | string<br /><br />StartTime |
|  end_time | No | string<br /><br />EndTime |
|  active | No | boolean<br /><br />Active |
|  details | No | string<br /><br />Detail |


<a id="HostNameBinding_properties" />
## HostNameBinding_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Hostname |
|  siteName | No | string<br /><br />Web app name |
|  domainId | No | string<br /><br />Fully qualified ARM domain resource URI |
|  azureResourceName | No | string<br /><br />Azure resource name |
|  azureResourceType | No | enum<br />**Website** or **TrafficManager**<br /><br />Azure resource type. |
|  customHostNameDnsRecordType | No | enum<br />**CName** or **A**<br /><br />Custom DNS record type. |
|  hostNameType | No | enum<br />**Verified** or **Managed**<br /><br />Host name type. |


<a id="ArmPlan" />
## ArmPlan object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />The name |
|  publisher | No | string<br /><br />The publisher |
|  product | No | string<br /><br />The product |
|  promotionCode | No | string<br /><br />The promotion code |
|  version | No | string<br /><br />Version of product |


<a id="RelayServiceConnectionEntity_properties" />
## RelayServiceConnectionEntity_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  entityName | No | string<br /> |
|  entityConnectionString | No | string<br /> |
|  resourceType | No | string<br /> |
|  resourceConnectionString | No | string<br /> |
|  hostname | No | string<br /> |
|  port | No | integer<br /> |
|  biztalkUri | No | string<br /> |


<a id="sites_virtualNetworkConnections_gateways_childResource" />
## sites_virtualNetworkConnections_gateways_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**gateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetGateway_properties object](#VnetGateway_properties)<br /> |


<a id="sites_slots_virtualNetworkConnections_gateways_childResource" />
## sites_slots_virtualNetworkConnections_gateways_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**gateways**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetGateway_properties object](#VnetGateway_properties)<br /> |


<a id="sites_slots_hybridconnection_childResource" />
## sites_slots_hybridconnection_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**hybridconnection**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties)<br /> |


<a id="sites_hybridconnection_childResource" />
## sites_hybridconnection_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**hybridconnection**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties)<br /> |


<a id="sites_slots_premieraddons_childResource" />
## sites_slots_premieraddons_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**premieraddons**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | No | object<br /><br />Tags associated with resource |
|  plan | No | object<br />[ArmPlan object](#ArmPlan)<br /><br />Azure resource manager plan |
|  properties | Yes | object<br /><br />Resource specific properties |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /><br />Sku description of the resource |


<a id="sites_premieraddons_childResource" />
## sites_premieraddons_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**premieraddons**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  location | No | string<br /><br />Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | No | object<br /><br />Tags associated with resource |
|  plan | No | object<br />[ArmPlan object](#ArmPlan)<br /><br />Azure resource manager plan |
|  properties | Yes | object<br /><br />Resource specific properties |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /><br />Sku description of the resource |


<a id="sites_slots_hostNameBindings_childResource" />
## sites_slots_hostNameBindings_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**hostNameBindings**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[HostNameBinding_properties object](#HostNameBinding_properties)<br /> |


<a id="sites_hostNameBindings_childResource" />
## sites_hostNameBindings_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**hostNameBindings**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[HostNameBinding_properties object](#HostNameBinding_properties)<br /> |


<a id="sites_slots_deployments_childResource" />
## sites_slots_deployments_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**deployments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Deployment_properties object](#Deployment_properties)<br /> |


<a id="sites_deployments_childResource" />
## sites_deployments_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**deployments**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Deployment_properties object](#Deployment_properties)<br /> |


<a id="sites_slots_childResource" />
## sites_slots_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**slots**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Site_properties object](#Site_properties)<br /> |
|  resources | No | array<br />[hybridconnection object](#hybridconnection)<br />[premieraddons object](#premieraddons)<br />[hostNameBindings object](#hostNameBindings)<br />[deployments object](#deployments)<br /> |


<a id="sites_virtualNetworkConnections_childResource" />
## sites_virtualNetworkConnections_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**virtualNetworkConnections**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetInfo_properties object](#VnetInfo_properties)<br /> |
|  resources | No | array<br />[gateways object](#gateways)<br /> |


<a id="sites_slots_virtualNetworkConnections_childResource" />
## sites_slots_virtualNetworkConnections_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**virtualNetworkConnections**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[VnetInfo_properties object](#VnetInfo_properties)<br /> |
|  resources | No | array<br />[gateways object](#gateways)<br /> |


<a id="hostingEnvironments_workerPools_childResource" />
## hostingEnvironments_workerPools_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**workerPools**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[WorkerPool_properties object](#WorkerPool_properties)<br /> |
|  sku | No | object<br />[SkuDescription object](#SkuDescription)<br /> |

