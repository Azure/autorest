import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ComponentContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(ComponentContainerResource)
model ComponentVersionResource is ProxyResource<ComponentVersion> {
  @doc("Version identifier.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface ComponentVersionResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get version.")
  @operationId("RegistryComponentVersions_Get")
  get is ArmResourceRead<ComponentVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update version.")
  @operationId("RegistryComponentVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ComponentVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete version.")
  @operationId("RegistryComponentVersions_Delete")
  delete is ArmResourceDeleteAsync<
    ComponentVersionResource,
    BaseParameters<ComponentVersionResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List versions.")
  @operationId("RegistryComponentVersions_List")
  list is ArmResourceListByParent<
    ComponentVersionResource,
    {
      ...BaseParameters<ComponentVersionResource>;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Component stage.")
      @query("stage")
      stage?: string;
    }
  >;
}

@@projectedName(ComponentVersionResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(ComponentVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(ComponentVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
