import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Integration.Spaces;
@doc("An integration space.")
model Space is TrackedResource<SpaceResourceProperties> {
  @doc("The name of the space")
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("spaceName")
  @segment("spaces")
  name: string;
}

@armResourceOperations
interface Spaces {
  @doc("Get a Space")
  get is ArmResourceRead<Space>;
  @doc("Create a Space")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Space>;
  @doc("Update a Space")
  patch is ArmResourcePatchSync<Space, SpaceResourceProperties>;
  @doc("Delete a Space")
  delete is ArmResourceDeleteAsync<Space>;
  @doc("List Space resources by resource group")
  listByResourceGroup is ArmResourceListByParent<
    Space,
    {
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
  @doc("List Space resources by subscription ID")
  listBySubscription is ArmListBySubscription<Space>;
}
