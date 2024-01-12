import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ModelContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(ModelContainerResource)
model ModelVersionResource is ProxyResource<ModelVersion> {
  @doc("Version identifier. This is case-sensitive.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface ModelVersionResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get version.")
  @operationId("RegistryModelVersions_Get")
  get is ArmResourceRead<ModelVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update version.")
  @operationId("RegistryModelVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ModelVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete version.")
  @operationId("RegistryModelVersions_Delete")
  delete is ArmResourceDeleteAsync<
    ModelVersionResource,
    BaseParameters<ModelVersionResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List versions.")
  @operationId("RegistryModelVersions_List")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Model Version Package operation.")
  @operationId("RegistryModelVersions_Package")
  package is ArmResourceActionAsync<
    ModelVersionResource,
    PackageRequest,
    PackageResponse,
    BaseParameters<ModelVersionResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Generate a storage location and credential for the client to upload a model asset to.")
  @operationId("RegistryModelVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    ModelVersionResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}

@@projectedName(ModelVersionResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(ModelVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ModelVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(ModelVersionResources.package::parameters.body,
  "Package operation request body."
);
@@doc(ModelVersionResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
