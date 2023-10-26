import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Describes a cloud service OS version.")
@locationResource
model OSVersion is ProxyResource<OSVersionProperties> {
  @doc("Name of the OS version.")
  @path
  @key("osVersionName")
  @segment("cloudServiceOsVersions")
  name: string;

  @doc("Resource name.")
  @visibility("read")
  name?: string;
}

@armResourceOperations
interface CloudServiceOperatingSystems {
  @doc("""
Gets properties of a guest operating system version that can be specified in
the XML service configuration (.cscfg) for a cloud service.
""")
  getOSVersion is ArmResourceRead<OSVersion>;
  @doc("""
Gets a list of all guest operating system versions available to be specified in
the XML service configuration (.cscfg) for a cloud service. Use nextLink
property in the response to get the next page of OS versions. Do this till
nextLink is null to fetch all the OS versions.
""")
  listOSVersions is ArmResourceListByParent<OSVersion>;
}
