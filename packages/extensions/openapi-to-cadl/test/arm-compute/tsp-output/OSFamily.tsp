import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a cloud service OS family.")
@subscriptionResource
@locationResource
model OSFamily is ProxyResource<OSFamilyProperties> {
  @doc("Name of the OS family.")
  @path
  @key("osFamilyName")
  @segment("cloudServiceOsFamilies")
  name: string;
}

@armResourceOperations
interface OSFamilies {
  @doc("""
Gets properties of a guest operating system family that can be specified in the
XML service configuration (.cscfg) for a cloud service.
""")
  getOSFamily is ArmResourceRead<OSFamily>;
  @doc("""
Gets a list of all guest operating system families available to be specified in
the XML service configuration (.cscfg) for a cloud service. Use nextLink
property in the response to get the next page of OS Families. Do this till
nextLink is null to fetch all the OS Families.
""")
  listOSFamilies is ArmResourceListByParent<
    OSFamily,
    {
      @doc("Name of the location that the OS families pertain to.")
      @path
      location: string;
    }
  >;
}
