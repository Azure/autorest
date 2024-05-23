import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataContainerResource.tsp";

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
@parentResource(DataContainerResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(DataVersionBase)
model DataVersionBaseResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = DataVersionBaseResource,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: DataVersionBase;
}

@armResourceOperations
interface DataVersionBaseResources {
  /**
   * Get version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataVersions_Get")
  get is ArmResourceRead<DataVersionBaseResource>;

  /**
   * Create or update version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DataVersionBaseResource>;

  /**
   * Delete version.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryDataVersions_Delete")
  delete is ArmResourceDeleteAsync<DataVersionBaseResource>;

  /**
   * List data versions in the data container
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataVersions_List")
  list is ArmResourceListByParent<
    DataVersionBaseResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DataVersionBaseResource>;

      /**
       * Please choose OrderBy value from ['createdtime', 'modifiedtime']
       */
      @query("$orderBy")
      $orderBy?: string;

      /**
       * Top count of results, top count cannot be greater than the page size.
       *                               If topCount > page size, results with be default page size count will be returned
       */
      @query("$top")
      $top?: int32;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2
       */
      @query("$tags")
      $tags?: string;

      /**
       * [ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;

  /**
   * Generate a storage location and credential for the client to upload a data asset to.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryDataVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    DataVersionBaseResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}

@@doc(DataVersionBaseResource.name, "Version identifier.");
@@encodedName(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(DataVersionBaseResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
