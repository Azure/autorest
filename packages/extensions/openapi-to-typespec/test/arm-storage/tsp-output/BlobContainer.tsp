import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BlobServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * Properties of the blob container, including Id, resource name, resource type, Etag.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(BlobServiceProperties)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ContainerProperties)
model BlobContainer extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = BlobContainer,
    KeyName = "containerName",
    SegmentName = "containers",
    NamePattern = ""
  >;

  /**
   * Properties of the blob container.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ContainerProperties;
}

@armResourceOperations
interface BlobContainers {
  /**
   * Gets properties of a specified container.
   */
  get is ArmResourceRead<BlobContainer>;

  /**
   * Creates a new container under the specified account as described by request body. The container resource includes metadata and properties for that container. It does not include a list of the blobs contained by the container.
   */
  create is ArmResourceCreateOrReplaceSync<BlobContainer>;

  /**
   * Updates container properties as specified in request body. Properties not mentioned in the request will be unchanged. Update fails if the specified container doesn't already exist.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<BlobContainer, BlobContainer>;

  /**
   * Deletes specified container under its account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<BlobContainer>;

  /**
   * Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobContainers_List")
  list is ArmResourceListByParent<
    BlobContainer,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BlobContainer>;

      /**
       * Optional. Specified maximum number of containers that can be included in the list.
       */
      @query("$maxpagesize")
      $maxpagesize?: string;

      /**
       * Optional. When specified, only container names starting with the filter will be listed.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Optional, used to include the properties for soft deleted blob containers.
       */
      @query("$include")
      $include?: ListContainersInclude;
    }
  >;

  /**
   * Sets legal hold tags. Setting the same tag results in an idempotent operation. SetLegalHold follows an append pattern and does not clear out the existing tags that are not specified in the request.
   */
  setLegalHold is ArmResourceActionSync<BlobContainer, LegalHold, LegalHold>;

  /**
   * Clears legal hold tags. Clearing the same or non-existent tag results in an idempotent operation. ClearLegalHold clears out only the specified tags in the request.
   */
  clearLegalHold is ArmResourceActionSync<BlobContainer, LegalHold, LegalHold>;

  /**
   * The Lease Container operation establishes and manages a lock on a container for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
   */
  lease is ArmResourceActionSync<
    BlobContainer,
    LeaseContainerRequest,
    LeaseContainerResponse
  >;

  /**
   * This operation migrates a blob container from container level WORM to object level immutability enabled container. Prerequisites require a container level immutability policy either in locked or unlocked state, Account level versioning must be enabled and there should be no Legal hold on the container.
   */
  objectLevelWorm is ArmResourceActionAsync<BlobContainer, void, void>;
}

@@maxLength(BlobContainer.name, 63);
@@minLength(BlobContainer.name, 3);
@@doc(BlobContainer.name,
  "The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number."
);
@@encodedName(BlobContainers.create::parameters.resource,
  "application/json",
  "blobContainer"
);
@@extension(BlobContainers.create::parameters.resource,
  "x-ms-client-name",
  "blobContainer"
);
@@doc(BlobContainers.create::parameters.resource,
  "Properties of the blob container to create."
);
@@encodedName(BlobContainers.update::parameters.properties,
  "application/json",
  "blobContainer"
);
@@extension(BlobContainers.update::parameters.properties,
  "x-ms-client-name",
  "blobContainer"
);
@@doc(BlobContainers.update::parameters.properties,
  "Properties to update for the blob container."
);
@@encodedName(BlobContainers.setLegalHold::parameters.body,
  "application/json",
  "LegalHold"
);
@@extension(BlobContainers.setLegalHold::parameters.body,
  "x-ms-client-name",
  "LegalHold"
);
@@doc(BlobContainers.setLegalHold::parameters.body,
  "The LegalHold property that will be set to a blob container."
);
@@encodedName(BlobContainers.clearLegalHold::parameters.body,
  "application/json",
  "LegalHold"
);
@@extension(BlobContainers.clearLegalHold::parameters.body,
  "x-ms-client-name",
  "LegalHold"
);
@@doc(BlobContainers.clearLegalHold::parameters.body,
  "The LegalHold property that will be clear from a blob container."
);
@@encodedName(BlobContainers.lease::parameters.body,
  "application/json",
  "parameters"
);
@@extension(BlobContainers.lease::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(BlobContainers.lease::parameters.body, "Lease Container request body.");
