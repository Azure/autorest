import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./FeaturestoreEntityContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(FeaturestoreEntityContainer)
model FeaturestoreEntityVersion
  is ProxyResource<FeaturestoreEntityVersionProperties> {
  /**
   * Version identifier. This is case-sensitive.
   */
  @path
  @key("version")
  @segment("versions")
  name: string;
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
  delete is ArmResourceDeleteAsync<
    FeaturestoreEntityVersion,
    BaseParameters<FeaturestoreEntityVersion>,
    ArmLroLocationHeader
  >;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FeaturestoreEntityVersions_List")
  list is ArmResourceListByParent<
    FeaturestoreEntityVersion,
    {
      ...BaseParameters<FeaturestoreEntityVersion>;

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

@@projectedName(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(FeaturestoreEntityVersions.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
