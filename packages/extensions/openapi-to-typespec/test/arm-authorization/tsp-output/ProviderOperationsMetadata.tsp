import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.Authorization;
// FIXME: ProviderOperationsMetadata has no properties property
/**
 * Provider Operations metadata
 */
@tenantResource
model ProviderOperationsMetadata is Azure.ResourceManager.ProxyResource<{}> {
  ...ResourceNameParameter<
    Resource = ProviderOperationsMetadata,
    KeyName = "resourceProviderNamespace",
    SegmentName = "providerOperations",
    NamePattern = ""
  >;

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
interface ProviderOperationsMetadataOperationGroup {
  /**
   * Gets provider operations metadata for the specified resource provider.
   */
  get is ArmResourceRead<
    ProviderOperationsMetadata,
    {
      ...Azure.ResourceManager.Foundations.TenantBaseParameters;

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
      ...Azure.ResourceManager.Foundations.TenantBaseParameters;

      /**
       * Specifies whether to expand the values.
       */
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;
}

@@doc(ProviderOperationsMetadata.name,
  "The namespace of the resource provider."
);
