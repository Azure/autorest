import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Space.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.IntegrationSpaces;
/**
 * An infrastructure resource under Space.
 */
@parentResource(Space)
model InfrastructureResource
  is Azure.ResourceManager.ProxyResource<InfrastructureResourceProperties> {
  ...ResourceNameParameter<
    Resource = InfrastructureResource,
    KeyName = "infrastructureResourceName",
    SegmentName = "infrastructureResources",
    NamePattern = "[a-zA-Z0-9_.()-]{0,79}$"
  >;
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
  @parameterVisibility
  patch is ArmCustomPatchSync<
    InfrastructureResource,
    PatchModel = InfrastructureResourceUpdate
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
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "select", explode: true })
      select?: string[];

      /**
       * Expand the indicated resources into the response.
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "expand", explode: true })
      expand?: string[];

      /**
       * Expressions that specify the order of returned results.
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "orderby", explode: true })
      orderby?: string[];
    }
  >;
}

@@doc(InfrastructureResource.name,
  "The name of the infrastructure resource in the space."
);
@@doc(InfrastructureResource.properties,
  "The resource-specific properties for this resource."
);
