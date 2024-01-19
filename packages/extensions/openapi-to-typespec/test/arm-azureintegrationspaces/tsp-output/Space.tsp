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
/**
 * An integration space.
 */
model Space is TrackedResource<SpaceResourceProperties> {
  /**
   * The name of the space
   */
  @pattern("[a-zA-Z0-9_.()-]{0,79}$")
  @path
  @key("spaceName")
  @segment("spaces")
  name: string;
}

@armResourceOperations
interface Spaces {
  /**
   * Get a Space
   */
  get is ArmResourceRead<Space>;

  /**
   * Create a Space
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Space>;

  /**
   * Update a Space
   */
  @parameterVisibility("read")
  patch is ArmCustomPatchSync<Space, SpaceUpdate>;

  /**
   * Delete a Space
   */
  delete is ArmResourceDeleteSync<Space>;

  /**
   * List Space resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Spaces_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    Space,
    {
      ...BaseParameters<Space>;

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

  /**
   * List Space resources by subscription ID
   */
  listBySubscription is ArmListBySubscription<Space>;
}
