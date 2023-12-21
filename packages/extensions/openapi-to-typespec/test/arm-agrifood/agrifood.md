```yaml
library-name: AgFoodPlatform
namespace: Azure.ResourceManager.AgFoodPlatform
isAzureSpec: true
isArm: true
require: https://github.com/Azure/azure-rest-api-specs/tree/7cc7728e5be252a7c6e559ea380411c8cceffa89/specification/agrifood/resource-manager/readme.md
skip-csproj: true
modelerfour:
  flatten-payloads: false

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
```
