```yaml
require: https://github.com/Azure/azure-rest-api-specs/blob/a89f3906ba60257ae28a2eed756a1ee4ca72ed51/specification/sphere/resource-manager/readme.md
title: "Azure Sphere resource management API."
clear-output-folder: false
guessResourceKey: false
isAzureSpec: true
isArm: true
namespace: "Azure.ResourceManager.Sphere"
```

### Config for csharp

```yaml
format-by-name-rules:
  "tenantId": "uuid"
  "ETag": "etag"
  "location": "azure-location"
  "*Uri": "Uri"
  "*Uris": "Uri"

acronym-mapping:
  CPU: Cpu
  CPUs: Cpus
  Os: OS
  Ip: IP
  Ips: IPs|ips
  ID: Id
  IDs: Ids
  VM: Vm
  VMs: Vms
  Vmos: VmOS
  VMScaleSet: VmScaleSet
  DNS: Dns
  VPN: Vpn
  NAT: Nat
  WAN: Wan
  Ipv4: IPv4|ipv4
  Ipv6: IPv6|ipv6
  Ipsec: IPsec|ipsec
  SSO: Sso
  URI: Uri
  Etag: ETag|etag

rename-mapping:
  Catalog: SphereCatalog
  ProvisioningState: SphereProvisioningState
  Certificate: SphereCertificate
  CertificateStatus: SphereCertificateStatus
  CertificateProperties: SphereCertificateProperties
  Deployment: SphereDeployment
  Device: SphereDevice
  DeviceGroup: SphereDeviceGroup
  Image: SphereImage
  Product: SphereProduct
  AllowCrashDumpCollection: SphereAllowCrashDumpCollectionStatus
  CapabilityType: SphereCapabilityType
  CertificateChainResponse: SphereCertificateChainResult
  CountDeviceResponse: CountDeviceResult
  CountElementsResponse: CountElementsResult
  DeviceInsight: SphereDeviceInsight
  ImageType: SphereImageType
  OSFeedType: SphereOSFeedType
  UpdatePolicy: SphereUpdatePolicy
  ClaimDevicesRequest: ClaimSphereDevicesContent
  ListDeviceGroupsRequest: ListSphereDeviceGroupsContent
```
