import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ModelContainerResource.tsp";

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
@parentResource(ModelContainerResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ModelVersion)
model ModelVersionResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = ModelVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: ModelVersion;
}

@armResourceOperations
interface ModelVersionResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelVersions_Get")
  get is ArmResourceRead<ModelVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<ModelVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryModelVersions_Delete")
  delete is ArmResourceDeleteAsync<ModelVersionResource>;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelVersions_List")
  list is ArmResourceListByParent<
    ModelVersionResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ModelVersionResource>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

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
       * Model description.
       */
      @query("description")
      description?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("tags")
      tags?: string;

      /**
       * Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2
       */
      @query("properties")
      properties?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;

  /**
   * Model Version Package operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelVersions_Package")
  package is ArmResourceActionAsync<
    ModelVersionResource,
    PackageRequest,
    PackageResponse
  >;

  /**
   * Generate a storage location and credential for the client to upload a model asset to.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryModelVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    ModelVersionResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}

@@doc(ModelVersionResource.name, "Version identifier. This is case-sensitive.");
@@encodedName(ModelVersionResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(ModelVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ModelVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(ModelVersionResources.package::parameters.body,
  "Package operation request body."
);
@@doc(ModelVersionResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
