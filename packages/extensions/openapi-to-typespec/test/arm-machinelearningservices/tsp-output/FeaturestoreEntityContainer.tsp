import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Workspace)
model FeaturestoreEntityContainer
  is Azure.ResourceManager.ProxyResource<
    FeaturestoreEntityContainerProperties,
    false
  > {
  ...ResourceNameParameter<
    Resource = FeaturestoreEntityContainer,
    KeyName = "name",
    SegmentName = "featurestoreEntities",
    NamePattern = ""
  >;
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    FeaturestoreEntityContainer,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List featurestore entity containers.
   */
  list is ArmResourceListByParent<
    FeaturestoreEntityContainer,
    Parameters = {
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
    },
    Response = ArmResponse<FeaturestoreEntityContainerResourceArmPaginatedResult>
  >;
}

@@doc(FeaturestoreEntityContainer.name,
  "Container name. This is case-sensitive."
);
@@doc(FeaturestoreEntityContainer.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(FeaturestoreEntityContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
