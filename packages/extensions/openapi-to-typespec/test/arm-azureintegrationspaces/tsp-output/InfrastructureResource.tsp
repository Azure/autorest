import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Space.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
/**
 * An infrastructure resource under Space.
 */
@parentResource(Space)
model InfrastructureResource
  is ProxyResource<InfrastructureResourceProperties> {
  /**
   * The name of the infrastructure resource in the space.
   */
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("infrastructureResourceName")
  @segment("infrastructureResources")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface InfrastructureResources {
  /**
   * Get a InfrastructureResource
   */
  get is ArmResourceRead<InfrastructureResource>;

  /**
   * Create a InfrastructureResource
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<InfrastructureResource>;

  /**
   * Update a InfrastructureResource
   */
  @parameterVisibility("read")
  patch is ArmCustomPatchSync<
    InfrastructureResource,
    InfrastructureResourceUpdate
  >;

  /**
   * Delete a InfrastructureResource
   */
  delete is ArmResourceDeleteSync<InfrastructureResource>;

  /**
   * List InfrastructureResource resources by Space
   */
  listBySpace is ArmResourceListByParent<
    InfrastructureResource,
    {
      ...BaseParameters<InfrastructureResource>;

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
