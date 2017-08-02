# Microsoft.ContainerService/containerServices template reference
API Version: 2016-03-30
## Template format

To create a Microsoft.ContainerService/containerServices resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.ContainerService/containerServices",
  "apiVersion": "2016-03-30",
  "location": "string",
  "tags": {},
  "properties": {
    "orchestratorProfile": {
      "orchestratorType": "string"
    },
    "masterProfile": {
      "count": "integer",
      "dnsPrefix": "string"
    },
    "agentPoolProfiles": [
      {
        "name": "string",
        "count": "integer",
        "vmSize": "string",
        "dnsPrefix": "string"
      }
    ],
    "windowsProfile": {
      "adminUsername": "string",
      "adminPassword": "string"
    },
    "linuxProfile": {
      "adminUsername": "string",
      "ssh": {
        "publicKeys": [
          {
            "keyData": "string"
          }
        ]
      }
    },
    "diagnosticsProfile": {
      "vmDiagnostics": {
        "enabled": boolean
      }
    }
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.ContainerService/containerServices" />
### Microsoft.ContainerService/containerServices object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.ContainerService/containerServices |
|  apiVersion | enum | Yes | 2016-03-30 |
|  location | string | Yes | Resource location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [ContainerServiceProperties object](#ContainerServiceProperties) |


<a id="ContainerServiceProperties" />
### ContainerServiceProperties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  orchestratorProfile | object | No | Properties of orchestrator - [ContainerServiceOrchestratorProfile object](#ContainerServiceOrchestratorProfile) |
|  masterProfile | object | Yes | Properties of master agents - [ContainerServiceMasterProfile object](#ContainerServiceMasterProfile) |
|  agentPoolProfiles | array | Yes | Properties of agent pools - [ContainerServiceAgentPoolProfile object](#ContainerServiceAgentPoolProfile) |
|  windowsProfile | object | No | Properties of Windows VMs - [ContainerServiceWindowsProfile object](#ContainerServiceWindowsProfile) |
|  linuxProfile | object | Yes | Properties for Linux VMs - [ContainerServiceLinuxProfile object](#ContainerServiceLinuxProfile) |
|  diagnosticsProfile | object | No | Properties for Diagnostic Agent - [ContainerServiceDiagnosticsProfile object](#ContainerServiceDiagnosticsProfile) |


<a id="ContainerServiceOrchestratorProfile" />
### ContainerServiceOrchestratorProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  orchestratorType | enum | No | Specifies what orchestrator will be used to manage container cluster resources. - Swarm or DCOS |


<a id="ContainerServiceMasterProfile" />
### ContainerServiceMasterProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  count | integer | No | Number of masters (VMs) in the container cluster |
|  dnsPrefix | string | Yes | DNS prefix to be used to create FQDN for master |


<a id="ContainerServiceAgentPoolProfile" />
### ContainerServiceAgentPoolProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes | Unique name of the agent pool profile within the context of the subscription and resource group |
|  count | integer | No | No. of agents (VMs) that will host docker containers |
|  vmSize | enum | No | Size of agent VMs. - Standard_A0, Standard_A1, Standard_A2, Standard_A3, Standard_A4, Standard_A5, Standard_A6, Standard_A7, Standard_A8, Standard_A9, Standard_A10, Standard_A11, Standard_D1, Standard_D2, Standard_D3, Standard_D4, Standard_D11, Standard_D12, Standard_D13, Standard_D14, Standard_D1_v2, Standard_D2_v2, Standard_D3_v2, Standard_D4_v2, Standard_D5_v2, Standard_D11_v2, Standard_D12_v2, Standard_D13_v2, Standard_D14_v2, Standard_G1, Standard_G2, Standard_G3, Standard_G4, Standard_G5, Standard_DS1, Standard_DS2, Standard_DS3, Standard_DS4, Standard_DS11, Standard_DS12, Standard_DS13, Standard_DS14, Standard_GS1, Standard_GS2, Standard_GS3, Standard_GS4, Standard_GS5 |
|  dnsPrefix | string | Yes | DNS prefix to be used to create FQDN for this agent pool |


<a id="ContainerServiceWindowsProfile" />
### ContainerServiceWindowsProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  adminUsername | string | Yes | The administrator username to use for Windows VMs |
|  adminPassword | string | Yes | The administrator password to use for Windows VMs |


<a id="ContainerServiceLinuxProfile" />
### ContainerServiceLinuxProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  adminUsername | string | Yes | The administrator username to use for all Linux VMs |
|  ssh | object | Yes | Specifies the ssh key configuration for Linux VMs - [ContainerServiceSshConfiguration object](#ContainerServiceSshConfiguration) |


<a id="ContainerServiceDiagnosticsProfile" />
### ContainerServiceDiagnosticsProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vmDiagnostics | object | No | Profile for container service VM diagnostic agent - [ContainerServiceVMDiagnostics object](#ContainerServiceVMDiagnostics) |


<a id="ContainerServiceSshConfiguration" />
### ContainerServiceSshConfiguration object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  publicKeys | array | No | the list of SSH public keys used to authenticate with Linux based VMs - [ContainerServiceSshPublicKey object](#ContainerServiceSshPublicKey) |


<a id="ContainerServiceVMDiagnostics" />
### ContainerServiceVMDiagnostics object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  enabled | boolean | No | whether VM Diagnostic Agent should be provisioned on the Virtual Machine. |


<a id="ContainerServiceSshPublicKey" />
### ContainerServiceSshPublicKey object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  keyData | string | Yes | Certificate public key used to authenticate with VM through SSH. The certificate must be in Pem format with or without headers. |

