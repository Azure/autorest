import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./DataContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(DataContainerResource)
model DataVersionBaseResource is ProxyResource<DataVersionBase> {
  @doc("Version identifier.")
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
@projectedName("client", "RegistryDataVersions")
interface DataVersionBaseResources_RegistryDataVersions {
  @doc("Get version.")
  get is ArmResourceRead<DataVersionBaseResource>;

  @doc("Create or update version.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DataVersionBaseResource>;

  @doc("Delete version.")
  delete is ArmResourceDeleteAsync<DataVersionBaseResource>;

  @doc("List data versions in the data container")
  list is ArmResourceListByParent<
    DataVersionBaseResource,
    {
      ...BaseParameters<DataVersionBaseResource>;

      @doc("Please choose OrderBy value from ['createdtime', 'modifiedtime']")
      @query("$orderBy")
      $orderBy?: string;

      @doc("""
Top count of results, top count cannot be greater than the page size.
                              If topCount > page size, results with be default page size count will be returned
""")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Comma-separated list of tag names (and optionally values). Example: tag1,tag2=value2")
      @query("$tags")
      $tags?: string;

      @doc("[ListViewType.ActiveOnly, ListViewType.ArchivedOnly, ListViewType.All]View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;

  @doc("Generate a storage location and credential for the client to upload a data asset to.")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    DataVersionBaseResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}
