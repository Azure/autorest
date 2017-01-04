# Microsoft.ContainerService template schema

Creates a Microsoft.ContainerService resource.

## Schema format

To create a Microsoft.ContainerService, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.ContainerService/containerServices",
  "apiVersion": "2016-03-30",
  "location": "string",
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
        "enabled": "boolean"
      }
    }
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="containerServices" />
## containerServices object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.ContainerService/containerServices**<br /> |
|  apiVersion | Yes | enum<br />**2016-03-30**<br /> |
|  location | Yes | string<br /><br />Resource location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[ContainerServiceProperties object](#ContainerServiceProperties)<br /> |


<a id="ContainerServiceProperties" />
## ContainerServiceProperties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  orchestratorProfile | No | object<br />[ContainerServiceOrchestratorProfile object](#ContainerServiceOrchestratorProfile)<br /><br />Properties of orchestrator |
|  masterProfile | Yes | object<br />[ContainerServiceMasterProfile object](#ContainerServiceMasterProfile)<br /><br />Properties of master agents |
|  agentPoolProfiles | Yes | array<br />[ContainerServiceAgentPoolProfile object](#ContainerServiceAgentPoolProfile)<br /><br />Properties of agent pools |
|  windowsProfile | No | object<br />[ContainerServiceWindowsProfile object](#ContainerServiceWindowsProfile)<br /><br />Properties of Windows VMs |
|  linuxProfile | Yes | object<br />[ContainerServiceLinuxProfile object](#ContainerServiceLinuxProfile)<br /><br />Properties for Linux VMs |
|  diagnosticsProfile | No | object<br />[ContainerServiceDiagnosticsProfile object](#ContainerServiceDiagnosticsProfile)<br /><br />Properties for Diagnostic Agent |


<a id="ContainerServiceOrchestratorProfile" />
## ContainerServiceOrchestratorProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  orchestratorType | No | enum<br />**Swarm** or **DCOS**<br /><br />Specifies what orchestrator will be used to manage container cluster resources. |


<a id="ContainerServiceMasterProfile" />
## ContainerServiceMasterProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  count | No | integer<br /><br />Number of masters (VMs) in the container cluster |
|  dnsPrefix | Yes | string<br /><br />DNS prefix to be used to create FQDN for master |


<a id="ContainerServiceAgentPoolProfile" />
## ContainerServiceAgentPoolProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | Yes | string<br /><br />Unique name of the agent pool profile within the context of the subscription and resource group |
|  count | No | integer<br /><br />No. of agents (VMs) that will host docker containers |
|  vmSize | No | enum<br />**Standard_A0**, **Standard_A1**, **Standard_A2**, **Standard_A3**, **Standard_A4**, **Standard_A5**, **Standard_A6**, **Standard_A7**, **Standard_A8**, **Standard_A9**, **Standard_A10**, **Standard_A11**, **Standard_D1**, **Standard_D2**, **Standard_D3**, **Standard_D4**, **Standard_D11**, **Standard_D12**, **Standard_D13**, **Standard_D14**, **Standard_D1_v2**, **Standard_D2_v2**, **Standard_D3_v2**, **Standard_D4_v2**, **Standard_D5_v2**, **Standard_D11_v2**, **Standard_D12_v2**, **Standard_D13_v2**, **Standard_D14_v2**, **Standard_G1**, **Standard_G2**, **Standard_G3**, **Standard_G4**, **Standard_G5**, **Standard_DS1**, **Standard_DS2**, **Standard_DS3**, **Standard_DS4**, **Standard_DS11**, **Standard_DS12**, **Standard_DS13**, **Standard_DS14**, **Standard_GS1**, **Standard_GS2**, **Standard_GS3**, **Standard_GS4**, **Standard_GS5**<br /><br />Size of agent VMs. |
|  dnsPrefix | Yes | string<br /><br />DNS prefix to be used to create FQDN for this agent pool |


<a id="ContainerServiceWindowsProfile" />
## ContainerServiceWindowsProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  adminUsername | Yes | string<br /><br />The administrator username to use for Windows VMs |
|  adminPassword | Yes | string<br /><br />The administrator password to use for Windows VMs |


<a id="ContainerServiceLinuxProfile" />
## ContainerServiceLinuxProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  adminUsername | Yes | string<br /><br />The administrator username to use for all Linux VMs |
|  ssh | Yes | object<br />[ContainerServiceSshConfiguration object](#ContainerServiceSshConfiguration)<br /><br />Specifies the ssh key configuration for Linux VMs |


<a id="ContainerServiceSshConfiguration" />
## ContainerServiceSshConfiguration object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  publicKeys | No | array<br />[ContainerServiceSshPublicKey object](#ContainerServiceSshPublicKey)<br /><br />the list of SSH public keys used to authenticate with Linux based VMs |


<a id="ContainerServiceSshPublicKey" />
## ContainerServiceSshPublicKey object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  keyData | Yes | string<br /><br />Certificate public key used to authenticate with VM through SSH. The certificate must be in Pem format with or without headers. |


<a id="ContainerServiceDiagnosticsProfile" />
## ContainerServiceDiagnosticsProfile object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  vmDiagnostics | No | object<br />[ContainerServiceVMDiagnostics object](#ContainerServiceVMDiagnostics)<br /><br />Profile for container service VM diagnostic agent |


<a id="ContainerServiceVMDiagnostics" />
## ContainerServiceVMDiagnostics object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  enabled | No | boolean<br /><br />whether VM Diagnostic Agent should be provisioned on the Virtual Machine. |

