import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./BlobContainer.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Storage;
@doc("""
The ImmutabilityPolicy property of a blob container, including Id, resource
name, resource type, Etag.
""")
@parentResource(BlobContainer)
@singleton("immutabilityPolicyName")
model ImmutabilityPolicy is ProxyResource<ImmutabilityPolicyProperty> {
  @key("immutabilityPolicyName")
  @segment("immutabilityPolicies")
  name: string;
}

@armResourceOperations
interface ImmutabilityPolicies {
  @doc("""
Gets the existing immutability policy along with the corresponding ETag in
response headers and body.
""")
  getImmutabilityPolicy is ArmResourceRead<ImmutabilityPolicy>;
  @doc("""
Creates or updates an unlocked immutability policy. ETag in If-Match is honored
if given but not required for this operation.
""")
  createOrUpdateImmutabilityPolicy is ArmResourceCreateOrUpdateAsync<ImmutabilityPolicy>;
  @doc("""
Aborts an unlocked immutability policy. The response of delete has
immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required
for this operation. Deleting a locked immutability policy is not allowed, the
only way is to delete the container after deleting all expired blobs inside the
policy locked container.
""")
  deleteImmutabilityPolicy is ArmResourceDeleteAsync<ImmutabilityPolicy>;
  @doc("""
Sets the ImmutabilityPolicy to Locked state. The only action allowed on a
Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required
for this operation.
""")
  lockImmutabilityPolicy is ArmResourceActionSync<
    ImmutabilityPolicy,
    {
      @doc("""
The entity state (ETag) version of the immutability policy to update. A value
of \"*\" can be used to apply the operation only if the immutability policy
already exists. If omitted, this operation will always be applied.
""")
      @header
      `If-Match`: string;
    },
    ImmutabilityPolicy
  >;
  @doc("""
Extends the immutabilityPeriodSinceCreationInDays of a locked
immutabilityPolicy. The only action allowed on a Locked policy will be this
action. ETag in If-Match is required for this operation.
""")
  extendImmutabilityPolicy is ArmResourceActionSync<
    ImmutabilityPolicy,
    {
      @doc("""
The entity state (ETag) version of the immutability policy to update. A value
of \"*\" can be used to apply the operation only if the immutability policy
already exists. If omitted, this operation will always be applied.
""")
      @header
      `If-Match`: string;

      ...ImmutabilityPolicy;
    },
    ImmutabilityPolicy
  >;
}
