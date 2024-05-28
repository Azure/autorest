import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ComponentContainerResource.tsp";

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
@parentResource(ComponentContainerResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ComponentVersion)
model ComponentVersionResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ComponentVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: ComponentVersion;
}

@armResourceOperations
interface ComponentVersionResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentVersions_Get")
  get is ArmResourceRead<ComponentVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ComponentVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryComponentVersions_Delete")
  delete is ArmResourceDeleteAsync<ComponentVersionResource>;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryComponentVersions_List")
  list is ArmResourceListByParent<
    ComponentVersionResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ComponentVersionResource>;

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
       * Component stage.
       */
      @query("stage")
      stage?: string;
    }
  >;
}

@@doc(ComponentVersionResource.name, "Version identifier.");
@@encodedName(ComponentVersionResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(ComponentVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ComponentVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
