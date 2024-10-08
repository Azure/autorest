import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FeaturestoreEntityContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(FeaturestoreEntityContainer)
model FeaturestoreEntityVersion
  is Azure.ResourceManager.ProxyResource<
    FeaturestoreEntityVersionProperties,
    false
  > {
  ...ResourceNameParameter<
    Resource = FeaturestoreEntityVersion,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface FeaturestoreEntityVersions {
  /**
   * Get version.
   */
  get is ArmResourceRead<FeaturestoreEntityVersion>;

  /**
   * Create or update version.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<FeaturestoreEntityVersion>;

  /**
   * Delete version.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<FeaturestoreEntityVersion>;

  /**
   * List versions.
   */
  list is ArmResourceListByParent<
    FeaturestoreEntityVersion,
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
       * name for the featurestore entity version
       */
      @query("versionName")
      versionName?: string;

      /**
       * description for the feature entity version
       */
      @query("description")
      description?: string;

      /**
       * createdBy user name
       */
      @query("createdBy")
      createdBy?: string;

      /**
       * Specifies the featurestore stage
       */
      @query("stage")
      stage?: string;
    }
  >;
}

@@doc(FeaturestoreEntityVersion.name,
  "Version identifier. This is case-sensitive."
);
@@doc(FeaturestoreEntityVersion.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
