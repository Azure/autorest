import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BlobContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * The ImmutabilityPolicy property of a blob container, including Id, resource name, resource type, Etag.
 */
@parentResource(BlobContainer)
model ImmutabilityPolicy
  is Azure.ResourceManager.ProxyResource<ImmutabilityPolicyProperty, false> {
  ...ResourceNameParameter<
    Resource = ImmutabilityPolicy,
    KeyName = "immutabilityPolicyName",
    SegmentName = "immutabilityPolicies",
    NamePattern = "",
    Type = "default"
  >;
}

@armResourceOperations
interface ImmutabilityPolicies {
  /**
   * Gets the existing immutability policy along with the corresponding ETag in response headers and body.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobContainers_GetImmutabilityPolicy")
  getImmutabilityPolicy is ArmResourceRead<
    ImmutabilityPolicy,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ImmutabilityPolicy>;

      /**
       * The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("BlobContainers_CreateOrUpdateImmutabilityPolicy")
  createOrUpdateImmutabilityPolicy is ArmResourceCreateOrReplaceSync<
    ImmutabilityPolicy,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ImmutabilityPolicy>;

      /**
       * The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, the only way is to delete the container after deleting all expired blobs inside the policy locked container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("BlobContainers_DeleteImmutabilityPolicy")
  deleteImmutabilityPolicy is ArmResourceDeleteSync<
    ImmutabilityPolicy,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<ImmutabilityPolicy>;

      /**
       * The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
       */
      @header
      `If-Match`: string;
    }
  >;
}

@@doc(ImmutabilityPolicy.name,
  "The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'"
);
@@doc(ImmutabilityPolicy.properties,
  "The properties of an ImmutabilityPolicy of a blob container."
);
@@encodedName(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy::parameters.resource,
  "The ImmutabilityPolicy Properties that will be created or updated to a blob container."
);
