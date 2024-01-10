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
@doc("Describes a cloud service OS family.")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets properties of a guest operating system family that can be specified in the XML service configuration (.cscfg) for a cloud service.")
  @operationId("CloudServiceOperatingSystems_GetOSFamily")
  getOSFamily is ArmResourceRead<OSFamily>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a list of all guest operating system families available to be specified in the XML service configuration (.cscfg) for a cloud service. Use nextLink property in the response to get the next page of OS Families. Do this till nextLink is null to fetch all the OS Families.")
  @operationId("CloudServiceOperatingSystems_ListOSFamilies")
  listOSFamilies is ArmResourceListByParent<OSFamily>;
}
