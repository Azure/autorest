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

namespace Microsoft.IntegrationSpaces;
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
  createOrUpdate is ArmResourceCreateOrReplaceSync<Space>;

  @doc("Update a Space")
  @parameterVisibility("read")
  patch is ArmCustomPatchSync<Space, SpaceUpdate>;

  @doc("Delete a Space")
  delete is ArmResourceDeleteSync<Space>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Space resources by resource group")
  @operationId("Spaces_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    Space,
    {
      ...BaseParameters<Space>;

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
