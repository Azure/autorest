import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./EnvironmentContainerResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
@doc("Azure Resource Manager resource envelope.")
@parentResource(EnvironmentContainerResource)
model EnvironmentVersionResource is ProxyResource<EnvironmentVersion> {
  @doc("Version identifier. This is case-sensitive.")
  @path
  @key("version")
  @segment("versions")
  name: string;
}

@armResourceOperations
interface EnvironmentVersionResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get version.")
  @operationId("RegistryEnvironmentVersions_Get")
  get is ArmResourceRead<EnvironmentVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update version.")
  @operationId("RegistryEnvironmentVersions_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<EnvironmentVersionResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete version.")
  @operationId("RegistryEnvironmentVersions_Delete")
  delete is ArmResourceDeleteAsync<
    EnvironmentVersionResource,
    BaseParameters<EnvironmentVersionResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List versions.")
  @operationId("RegistryEnvironmentVersions_List")
  list is ArmResourceListByParent<
    EnvironmentVersionResource,
    {
      ...BaseParameters<EnvironmentVersionResource>;

      @doc("Ordering of list.")
      @query("$orderBy")
      $orderBy?: string;

      @doc("Maximum number of records to return.")
      @query("$top")
      $top?: int32;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("View type for including/excluding (for example) archived entities.")
      @query("listViewType")
      listViewType?: ListViewType;

      @doc("Stage for including/excluding (for example) archived entities. Takes priority over listViewType")
      @query("stage")
      stage?: string;
    }
  >;
}

@@projectedName(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(EnvironmentVersionResources.createOrUpdate::parameters.resource,
  "Version entity to create or update."
);
