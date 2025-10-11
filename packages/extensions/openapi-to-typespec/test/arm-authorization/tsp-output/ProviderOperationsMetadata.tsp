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
/** Provider Operations metadata */
@tenantResource
model ProviderOperationsMetadata is Azure.ResourceManager.ProxyResource<{}> {
  ...ResourceNameParameter<
    Resource = ProviderOperationsMetadata,
    KeyName = "resourceProviderNamespace",
    SegmentName = "providerOperations",
    NamePattern = ""
  >;

  /** The provider display name. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  displayName?: string;

  /** The provider resource types */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @identifiers(#["name"])
  resourceTypes?: AuthorizationProviderResourceType[];

  /** The provider operations. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @identifiers(#[])
  operations?: ProviderOperation[];
}

@armResourceOperations
interface ProviderOperationsMetadataOperationGroup {
  /** Gets provider operations metadata for the specified resource provider. */
  get is ArmResourceRead<
    ProviderOperationsMetadata,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    Parameters = {
      /** Specifies whether to expand the values. */
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;

  /** Gets provider operations metadata for all resource providers. */
  list is ArmResourceListByParent<
    ProviderOperationsMetadata,
    BaseParameters = Azure.ResourceManager.Foundations.TenantBaseParameters,
    Parameters = {
      /** Specifies whether to expand the values. */
      @query("$expand")
      $expand?: string = "resourceTypes";
    }
  >;
}

@@doc(ProviderOperationsMetadata.name,
  "The namespace of the resource provider."
);
