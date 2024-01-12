import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(DataContainerResource)
model DataVersionBaseResource is ProxyResource<DataVersionBase> {
  @doc("Version identifier.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface DataVersionBaseResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get version.")
  @operationId("RegistryDataVersions_Get")
  get is ArmResourceRead<DataVersionBaseResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update version.")
  @operationId("RegistryDataVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DataVersionBaseResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete version.")
  @operationId("RegistryDataVersions_Delete")
  delete is ArmResourceDeleteAsync<
    DataVersionBaseResource,
    BaseParameters<DataVersionBaseResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List data versions in the data container")
  @operationId("RegistryDataVersions_List")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Generate a storage location and credential for the client to upload a data asset to.")
  @operationId("RegistryDataVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    DataVersionBaseResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}

@@projectedName(DataVersionBaseResources.createOrUpdate::parameters.resource,
  "json",
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
