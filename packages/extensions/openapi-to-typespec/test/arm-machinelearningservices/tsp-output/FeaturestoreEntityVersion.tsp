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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(FeaturestoreEntityContainer)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  FeaturestoreEntityVersionProperties
)
model FeaturestoreEntityVersion extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = FeaturestoreEntityVersion,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: FeaturestoreEntityVersionProperties;
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FeaturestoreEntityVersions_List")
  list is ArmResourceListByParent<
    FeaturestoreEntityVersion,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<FeaturestoreEntityVersion>;

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
@@encodedName(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
