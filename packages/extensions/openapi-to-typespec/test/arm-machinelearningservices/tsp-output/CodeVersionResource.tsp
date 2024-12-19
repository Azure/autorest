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
@parentResource(CodeContainerResource)
model CodeVersionResource
  is Azure.ResourceManager.ProxyResource<CodeVersion, false> {
  ...ResourceNameParameter<
    Resource = CodeVersionResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface CodeVersionResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryCodeVersions_Get")
  get is ArmResourceRead<CodeVersionResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryCodeVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CodeVersionResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("RegistryCodeVersions_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    CodeVersionResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("RegistryCodeVersions_List")
  list is ArmResourceListByParent<
    CodeVersionResource,
    Parameters = {
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
    },
    Response = ArmResponse<CodeVersionResourceArmPaginatedResult>
  >;

  /**
   * Generate a storage location and credential for the client to upload a code asset to.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("startPendingUpload")
  @operationId("RegistryCodeVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    CodeVersionResource,
    PendingUploadRequestDto,
    ArmResponse<PendingUploadResponseDto>
  >;
}

@@doc(CodeVersionResource.name, "Version identifier.");
@@doc(CodeVersionResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(CodeVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(CodeVersionResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
