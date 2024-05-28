import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Application.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
/**
 * A business process under application.
 */
@parentResource(Application)
model BusinessProcess
  is Azure.ResourceManager.ProxyResource<BusinessProcessProperties> {
  ...ResourceNameParameter<
    Resource = BusinessProcess,
    KeyName = "businessProcessName",
    SegmentName = "businessProcesses",
    NamePattern = "[a-zA-Z0-9_.()-]{0,79}$"
  >;
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
  @parameterVisibility
  patch is ArmCustomPatchSync<BusinessProcess, BusinessProcessUpdate>;

  /**
   * Delete a BusinessProcess
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<BusinessProcess>;

  /**
   * List BusinessProcess resources by Application
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BusinessProcesses_ListByApplication")
  listByApplication is ArmResourceListByParent<
    BusinessProcess,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BusinessProcess>;

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

@@doc(BusinessProcess.name, "The name of the business process");
