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
  FeaturestoreEntityContainerProperties
)
model FeaturestoreEntityContainer extends ProxyResourceBase {
  /**
   * Container name. This is case-sensitive.
   */
  @path
  @key("name")
  @segment("featurestoreEntities")
  @visibility("read")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: FeaturestoreEntityContainerProperties;
}

@armResourceOperations
interface FeaturestoreEntityContainers {
  /**
   * Get container.
   */
  getEntity is ArmResourceRead<FeaturestoreEntityContainer>;

  /**
   * Create or update container.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<FeaturestoreEntityContainer>;

  /**
   * Delete container.
   */
  delete is ArmResourceDeleteAsync<
    FeaturestoreEntityContainer,
    BaseParameters<FeaturestoreEntityContainer>,
    ArmLroLocationHeader
  >;

  /**
   * List featurestore entity containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FeaturestoreEntityContainers_List")
  list is ArmResourceListByParent<
    FeaturestoreEntityContainer,
    {
      ...BaseParameters<FeaturestoreEntityContainer>;

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
       * description for the featurestore entity
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

@@projectedName(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
