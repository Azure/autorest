import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  FeaturesetContainerProperties
)
model FeaturesetContainer extends ProxyResourceBase {
  /**
   * Container name. This is case-sensitive.
   */
  @path
  @key("name")
  @segment("featuresets")
  @visibility("read")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: FeaturesetContainerProperties;
}

@armResourceOperations
interface FeaturesetContainers {
  /**
   * Get container.
   */
  getEntity is ArmResourceRead<FeaturesetContainer>;

  /**
   * Create or update container.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<FeaturesetContainer>;

  /**
   * Delete container.
   */
  delete is ArmResourceDeleteAsync<FeaturesetContainer>;

  /**
   * List featurestore entity containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FeaturesetContainers_List")
  list is ArmResourceListByParent<
    FeaturesetContainer,
    {
      ...BaseParameters<FeaturesetContainer>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("tags")
      tags?: string;

      /**
       * [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * page size
       */
      @query("pageSize")
      pageSize?: int32 = 20;

      /**
       * description for the feature set
       */
      @query("description")
      description?: string;

      /**
       * createdBy user name
       */
      @query("createdBy")
      createdBy?: string;
    }
  >;
}

@@projectedName(FeaturesetContainers.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(FeaturesetContainers.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(FeaturesetContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
