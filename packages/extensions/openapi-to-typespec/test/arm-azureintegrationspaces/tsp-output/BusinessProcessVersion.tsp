import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BusinessProcess.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
/**
 * A business process version.
 */
@parentResource(BusinessProcess)
model BusinessProcessVersion
  is Azure.ResourceManager.ProxyResource<BusinessProcessProperties> {
  ...ResourceNameParameter<
    Resource = BusinessProcessVersion,
    KeyName = "businessProcessVersion",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface BusinessProcessVersions {
  /**
   * Get a BusinessProcessVersion
   */
  get is ArmResourceRead<BusinessProcessVersion>;

  /**
   * List BusinessProcessVersion resources by BusinessProcess
   */
  listByBusinessProcess is ArmResourceListByParent<
    BusinessProcessVersion,
    Parameters = {
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
      @query(#{ name: "select", explode: true })
      select?: string[];

      /**
       * Expand the indicated resources into the response.
       */
      @query(#{ name: "expand", explode: true })
      expand?: string[];

      /**
       * Expressions that specify the order of returned results.
       */
      @query(#{ name: "orderby", explode: true })
      orderby?: string[];
    },
    Response = BusinessProcessVersionListResult
  >;
}

@@doc(BusinessProcessVersion.name, "The version of the business process");
@@doc(BusinessProcessVersion.properties,
  "The resource-specific properties for this resource."
);
