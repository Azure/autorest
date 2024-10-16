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
 * A resource under application.
 */
@parentResource(Application)
model ApplicationResource
  is Azure.ResourceManager.ProxyResource<ApplicationResourceProperties> {
  ...ResourceNameParameter<
    Resource = ApplicationResource,
    KeyName = "resourceName",
    SegmentName = "resources",
    NamePattern = "[a-zA-Z0-9_.()-]{0,79}$"
  >;
}

@armResourceOperations
interface ApplicationResources {
  /**
   * Get a ApplicationResource
   */
  get is ArmResourceRead<ApplicationResource>;

  /**
   * Create a ApplicationResource
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ApplicationResource>;

  /**
   * Update a ApplicationResource
   */
  @parameterVisibility
  patch is ArmCustomPatchSync<ApplicationResource, ApplicationResourceUpdate>;

  /**
   * Delete a ApplicationResource
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<ApplicationResource>;

  /**
   * List ApplicationResource resources by Application
   */
  listByApplication is ArmResourceListByParent<
    ApplicationResource,
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
    Response = ApplicationResourceListResult
  >;
}

@@doc(ApplicationResource.name, "The name of the application resource.");
@@doc(ApplicationResource.properties,
  "The resource-specific properties for this resource."
);
