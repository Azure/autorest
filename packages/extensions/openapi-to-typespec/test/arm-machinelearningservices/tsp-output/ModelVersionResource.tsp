import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ModelContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(ModelContainerResource)
model ModelVersionResource is ProxyResource<ModelVersion> {
  @doc("Version identifier. This is case-sensitive.")
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
@projectedName("client", "RegistryModelVersions")
interface ModelVersionResources_RegistryModelVersions {
  @doc("Get version.")
  get is ArmResourceRead<ModelVersionResource>;

  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ModelVersionResource>;

  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<ModelVersionResource>;

  @doc("List versions.")
  list is ArmResourceListByParent<
    ModelVersionResource,
    {
      ...BaseParameters<ModelVersionResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Model description.")
      @query("description")
      description?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("tags")
      tags?: string;

      @doc("Comma-separated list of property names (and optionally values). Example: prop1,prop2=value2")
      @query("properties")
      properties?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;

  @doc("Model Version Package operation.")
  package is ArmResourceActionAsync<
    ModelVersionResource,
    PackageRequest,
    PackageResponse
  >;

  @doc("Generate a storage location and credential for the client to upload a model asset to.")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    ModelVersionResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}
