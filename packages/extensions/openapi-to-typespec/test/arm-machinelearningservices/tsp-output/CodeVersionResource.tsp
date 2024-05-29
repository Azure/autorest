import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CodeContainerResource.tsp";

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
@parentResource(CodeContainerResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(CodeVersion)
model CodeVersionResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = CodeVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: CodeVersion;
}

@armResourceOperations
interface CodeVersionResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeVersions_Get")
  get is ArmResourceRead<CodeVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CodeVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryCodeVersions_Delete")
  delete is ArmResourceDeleteAsync<CodeVersionResource>;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeVersions_List")
  list is ArmResourceListByParent<
    CodeVersionResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CodeVersionResource>;

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
    }
  >;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    CodeVersionResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}

@@doc(CodeVersionResource.name, "Version identifier.");
@@encodedName(CodeVersionResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(CodeVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(CodeVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(CodeVersionResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
