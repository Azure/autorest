import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Authorization;
// FIXME: ProviderOperationsMetadata has no properties property
@doc("Provider Operations metadata")
@tenantResource
model ProviderOperationsMetadata is ProxyResource<{}> {
  @doc("The namespace of the resource provider.")
  @key("resourceProviderNamespace")
  @segment("providerOperations")
  name: string;

  @doc("The provider display name.")
  displayName?: string;

  @doc("The provider resource types")
  resourceTypes?: AuthorizationProviderResourceType[];

  @doc("The provider operations.")
  operations?: ProviderOperation[];
}

@armResourceOperations
@projectedName("client", "ProviderOperationsMetadata")
interface ProviderOperationsMetadataOperationGroup {
  @doc("Gets provider operations metadata for the specified resource provider.")
  get is ArmResourceRead<
    ProviderOperationsMetadata,
    {
      ...BaseParameters<ProviderOperationsMetadata>;

      @doc("Specifies whether to expand the values.")
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;

  @doc("Gets provider operations metadata for all resource providers.")
  list is ArmResourceListByParent<
    ProviderOperationsMetadata,
    {
      ...BaseParameters<ProviderOperationsMetadata>;

      @doc("Specifies whether to expand the values.")
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;
}
