import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CodeContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(CodeContainerResource)
model CodeVersionResource is ProxyResource<CodeVersion> {
  @doc("Version identifier.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface CodeVersionResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get version.")
  @operationId("RegistryCodeVersions_Get")
  get is ArmResourceRead<CodeVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update version.")
  @operationId("RegistryCodeVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<CodeVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete version.")
  @operationId("RegistryCodeVersions_Delete")
  delete is ArmResourceDeleteAsync<
    CodeVersionResource,
    BaseParameters<CodeVersionResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List versions.")
  @operationId("RegistryCodeVersions_List")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Generate a storage location and credential for the client to upload a code asset to.")
  @operationId("RegistryCodeVersions_CreateOrGetStartPendingUpload")
  createOrGetStartPendingUpload is ArmResourceActionSync<
    CodeVersionResource,
    PendingUploadRequestDto,
    PendingUploadResponseDto
  >;
}

@@projectedName(CodeVersionResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(CodeVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(CodeVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
@@doc(CodeVersionResources.createOrGetStartPendingUpload::parameters.body,
  "Pending upload request object"
);
