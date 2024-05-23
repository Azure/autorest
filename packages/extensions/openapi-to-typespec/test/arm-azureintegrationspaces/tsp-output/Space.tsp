import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
/**
 * An integration space.
 */
model Space is Azure.ResourceManager.TrackedResource<SpaceResourceProperties> {
  ...ResourceNameParameter<
    Resource = Space,
    KeyName = "spaceName",
    SegmentName = "spaces",
    NamePattern = "[a-zA-Z0-9_.()-]{0,79}$"
  >;
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
  @parameterVisibility
  patch is ArmCustomPatchSync<Space, SpaceUpdate>;

  /**
   * Delete a Space
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<Space>;

  /**
   * List Space resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Spaces_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    Space,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Space>;

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

@@doc(Space.name, "The name of the space");
