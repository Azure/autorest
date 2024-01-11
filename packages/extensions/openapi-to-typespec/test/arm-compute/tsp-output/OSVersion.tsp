import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
@doc("Describes a cloud service OS version.")
@locationResource
model OSVersion is ProxyResource<OSVersionProperties> {
  @doc("Name of the OS version.")
  @path
  @key("osVersionName")
  @segment("cloudServiceOsVersions")
  name: string;
}

@armResourceOperations
interface OSVersions {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets properties of a guest operating system version that can be specified in the XML service configuration (.cscfg) for a cloud service.")
  @operationId("CloudServiceOperatingSystems_GetOSVersion")
  getOSVersion is ArmResourceRead<OSVersion>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a list of all guest operating system versions available to be specified in the XML service configuration (.cscfg) for a cloud service. Use nextLink property in the response to get the next page of OS versions. Do this till nextLink is null to fetch all the OS versions.")
  @operationId("CloudServiceOperatingSystems_ListOSVersions")
  listOSVersions is ArmResourceListByParent<OSVersion>;
}
