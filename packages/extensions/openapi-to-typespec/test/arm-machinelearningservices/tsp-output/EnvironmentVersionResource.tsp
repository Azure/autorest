import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./EnvironmentContainerResource.tsp";

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
@parentResource(EnvironmentContainerResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(EnvironmentVersion)
model EnvironmentVersionResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = EnvironmentVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: EnvironmentVersion;
}

@armResourceOperations
interface EnvironmentVersionResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryEnvironmentVersions_Get")
  get is ArmResourceRead<EnvironmentVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryEnvironmentVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<EnvironmentVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryEnvironmentVersions_Delete")
  delete is ArmResourceDeleteAsync<EnvironmentVersionResource>;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryEnvironmentVersions_List")
  list is ArmResourceListByParent<
    EnvironmentVersionResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<EnvironmentVersionResource>;

      /**
       * Ordering of list.
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Maximum number of records to return.
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;

      /**
       * Stage for including/excluding (for example) archived entities. Takes priority over listViewType
       */
      @query("stage")
      stage?: string;
    }
  >;
}

@@doc(EnvironmentVersionResource.name,
  "Version identifier. This is case-sensitive."
);
@@encodedName(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
