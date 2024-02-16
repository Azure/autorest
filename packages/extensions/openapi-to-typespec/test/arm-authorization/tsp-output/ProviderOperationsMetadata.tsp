import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Authorization;
// FIXME: ProviderOperationsMetadata has no properties property
/**
 * Provider Operations metadata
 */
@tenantResource
model ProviderOperationsMetadata is ProxyResource<{}> {
  /**
   * The namespace of the resource provider.
   */
  @path
  @key("resourceProviderNamespace")
  @segment("providerOperations")
  @visibility("read")
  name: string;

  /**
   * The provider display name.
   */
  displayName?: string;

  /**
   * The provider resource types
   */
  resourceTypes?: AuthorizationProviderResourceType[];

  /**
   * The provider operations.
   */
  operations?: ProviderOperation[];
}

@armResourceOperations
@projectedName("client", "ProviderOperationsMetadata")
interface ProviderOperationsMetadataOperationGroup {
  /**
   * Gets provider operations metadata for the specified resource provider.
   */
  get is ArmResourceRead<
    ProviderOperationsMetadata,
    {
      ...BaseParameters<ProviderOperationsMetadata>;

      /**
       * Specifies whether to expand the values.
       */
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;

  /**
   * Gets provider operations metadata for all resource providers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ProviderOperationsMetadata_List")
  list is ArmResourceListByParent<
    ProviderOperationsMetadata,
    {
      ...BaseParameters<ProviderOperationsMetadata>;

      /**
       * Specifies whether to expand the values.
       */
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;
}
