import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Application.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
@doc("A business process under application.")
@parentResource(Application)
model BusinessProcess is ProxyResource<BusinessProcessProperties> {
  @doc("The name of the business process")
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("businessProcessName")
  @segment("businessProcesses")
  name: string;
}

@armResourceOperations
interface BusinessProcesses {
  @doc("Get a BusinessProcess")
  get is ArmResourceRead<BusinessProcess>;

  @doc("Create a BusinessProcess")
  createOrUpdate is ArmResourceCreateOrReplaceSync<BusinessProcess>;

  @doc("Update a BusinessProcess")
  patch is ArmCustomPatchSync<BusinessProcess, BusinessProcessUpdate>;

  @doc("Delete a BusinessProcess")
  delete is ArmResourceDeleteSync<BusinessProcess>;

  @doc("List BusinessProcess resources by Application")
  listByApplication is ArmResourceListByParent<
    BusinessProcess,
    {
      ...BaseParameters<BusinessProcess>;

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
