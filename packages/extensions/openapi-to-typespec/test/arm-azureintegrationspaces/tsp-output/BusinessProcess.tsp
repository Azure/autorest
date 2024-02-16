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
/**
 * A business process under application.
 */
@parentResource(Application)
model BusinessProcess is ProxyResource<BusinessProcessProperties> {
  /**
   * The name of the business process
   */
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("businessProcessName")
  @segment("businessProcesses")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface BusinessProcesses {
  /**
   * Get a BusinessProcess
   */
  get is ArmResourceRead<BusinessProcess>;

  /**
   * Create a BusinessProcess
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<BusinessProcess>;

  /**
   * Update a BusinessProcess
   */
  @parameterVisibility("read")
  patch is ArmCustomPatchSync<BusinessProcess, BusinessProcessUpdate>;

  /**
   * Delete a BusinessProcess
   */
  delete is ArmResourceDeleteSync<BusinessProcess>;

  /**
   * List BusinessProcess resources by Application
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BusinessProcesses_ListByApplication")
  listByApplication is ArmResourceListByParent<
    BusinessProcess,
    {
      ...BaseParameters<BusinessProcess>;

      /**
       * The number of result items to return.
       */
      @query("top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("maxpagesize")
      maxpagesize?: int32;

      /**
       * Filter the result list using the given expression.
       */
      @query("filter")
      filter?: string;

      /**
       * Select the specified fields to be included in the response.
       */
      @query({
        name: "select",
        format: "multi",
      })
      select?: string[];

      /**
       * Expand the indicated resources into the response.
       */
      @query({
        name: "expand",
        format: "multi",
      })
      expand?: string[];

      /**
       * Expressions that specify the order of returned results.
       */
      @query({
        name: "orderby",
        format: "multi",
      })
      orderby?: string[];
    }
  >;
}
