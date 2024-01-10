import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./BlobContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
@doc("The ImmutabilityPolicy property of a blob container, including Id, resource name, resource type, Etag.")
@singleton("default")
@parentResource(BlobContainer)
model ImmutabilityPolicy is ProxyResource<ImmutabilityPolicyProperty> {
  @key("immutabilityPolicy")
  @segment("immutabilityPolicies")
  name: string;
}

@armResourceOperations
interface ImmutabilityPolicies {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the existing immutability policy along with the corresponding ETag in response headers and body.")
  @operationId("BlobContainers_GetImmutabilityPolicy")
  getImmutabilityPolicy is ArmResourceRead<
    ImmutabilityPolicy,
    {
      ...BaseParameters<ImmutabilityPolicy>;

      @doc("The entity state (ETag) version of the immutability policy to update. A value of \"*\" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.")
  @operationId("BlobContainers_CreateOrUpdateImmutabilityPolicy")
  createOrUpdateImmutabilityPolicy is ArmResourceCreateOrReplaceSync<
    ImmutabilityPolicy,
    {
      ...BaseParameters<ImmutabilityPolicy>;

      @doc("The entity state (ETag) version of the immutability policy to update. A value of \"*\" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, the only way is to delete the container after deleting all expired blobs inside the policy locked container.")
  @operationId("BlobContainers_DeleteImmutabilityPolicy")
  deleteImmutabilityPolicy is ArmResourceDeleteSync<
    ImmutabilityPolicy,
    {
      ...BaseParameters<ImmutabilityPolicy>;

      @doc("The entity state (ETag) version of the immutability policy to update. A value of \"*\" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Sets the ImmutabilityPolicy to Locked state. The only action allowed on a Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required for this operation.")
  @operationId("BlobContainers_LockImmutabilityPolicy")
  lockImmutabilityPolicy is ArmResourceActionSync<
    ImmutabilityPolicy,
    void,
    ImmutabilityPolicy,
    {
      ...BaseParameters<ImmutabilityPolicy>;

      @doc("The entity state (ETag) version of the immutability policy to update. A value of \"*\" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Extends the immutabilityPeriodSinceCreationInDays of a locked immutabilityPolicy. The only action allowed on a Locked policy will be this action. ETag in If-Match is required for this operation.")
  @operationId("BlobContainers_ExtendImmutabilityPolicy")
  extendImmutabilityPolicy is ArmResourceActionSync<
    ImmutabilityPolicy,
    ImmutabilityPolicy,
    ImmutabilityPolicy,
    {
      ...BaseParameters<ImmutabilityPolicy>;

      @doc("The entity state (ETag) version of the immutability policy to update. A value of \"*\" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.")
      @header
      `If-Match`: string;
    }
  >;
}
