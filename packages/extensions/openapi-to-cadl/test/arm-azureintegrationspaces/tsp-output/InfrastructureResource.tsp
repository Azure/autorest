import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Space.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.IntegrationSpaces;
@doc("An infrastructure resource under Space.")
@parentResource(Space)
model InfrastructureResource
  is ProxyResource<InfrastructureResourceProperties> {
  @doc("The name of the infrastructure resource in the space.")
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("infrastructureResourceName")
  @segment("infrastructureResources")
  name: string;
}

@armResourceOperations
interface InfrastructureResources {
  @doc("Get a InfrastructureResource")
  get is ArmResourceRead<InfrastructureResource>;
  @doc("Create a InfrastructureResource")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<InfrastructureResource>;
  @doc("Update a InfrastructureResource")
  patch is ArmResourcePatchSync<
    InfrastructureResource,
    InfrastructureResourceProperties
  >;
  @doc("Delete a InfrastructureResource")
  delete is ArmResourceDeleteAsync<InfrastructureResource>;
  @doc("List InfrastructureResource resources by Space")
  listBySpace is ArmResourceListByParent<
    InfrastructureResource,
    {
      ...BaseParameters<InfrastructureResource>;

      @doc("The number of result items to return.")
      @query("top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("maxpagesize")
      maxpagesize?: int32;

      @doc("Filter the result list using the given expression.")
      @query("filter")
      filter?: string;

      @doc("Select the specified fields to be included in the response.")
      @query({
        name: "select",
        format: "multi",
      })
      select?: string[];

      @doc("Expand the indicated resources into the response.")
      @query({
        name: "expand",
        format: "multi",
      })
      expand?: string[];

      @doc("Expressions that specify the order of returned results.")
      @query({
        name: "orderby",
        format: "multi",
      })
      orderby?: string[];
    }
  >;
}
