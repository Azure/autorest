import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./CodeContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(CodeContainerResource)
model CodeVersionResource is ProxyResource<CodeVersion> {
  @doc("Version identifier.")
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface RegistryCodeVersions {
  @doc("Get version.")
  get is ArmResourceRead<CodeVersionResource>;
  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CodeVersionResource>;
  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<CodeVersionResource>;
  @doc("List versions.")
  list is ArmResourceListByParent<
    CodeVersionResource,
    {
      ...BaseParameters<CodeVersionResource>;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;
    }
  >;
  @doc("Generate a storage location and credential for the client to upload a code asset to.")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    CodeVersionResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}
