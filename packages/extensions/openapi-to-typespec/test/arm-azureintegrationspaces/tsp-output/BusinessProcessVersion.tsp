import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BusinessProcess.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
@doc("A business process version.")
@parentResource(BusinessProcess)
model BusinessProcessVersion is ProxyResource<BusinessProcessProperties> {
  @doc("The version of the business process")
  @path
  @key("businessProcessVersion")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface BusinessProcessVersions {
  @doc("Get a BusinessProcessVersion")
  get is ArmResourceRead<BusinessProcessVersion>;

  @doc("List BusinessProcessVersion resources by BusinessProcess")
  listByBusinessProcess is ArmResourceListByParent<
    BusinessProcessVersion,
    {
      ...BaseParameters<BusinessProcessVersion>;

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
