import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Quota;
/**
 * Resource usage.
 */
@extensionResource
model CurrentUsagesBase
  is Azure.ResourceManager.ExtensionResource<UsagesProperties> {
  ...ResourceNameParameter<
    Resource = CurrentUsagesBase,
    KeyName = "resourceName",
    SegmentName = "usages",
    NamePattern = ""
  >;
}

@armResourceOperations
interface CurrentUsagesBases {
  /**
   * Get the current usage of a resource.
   */
  get is Extension.Read<Extension.ScopeParameter, CurrentUsagesBase>;

  /**
   * Get a list of current usage for all resources for the scope specified.
   */
  list is Extension.ListByTarget<
    Extension.ScopeParameter,
    CurrentUsagesBase,
    Response = ArmResponse<UsagesLimits>
  >;
}

@@doc(CurrentUsagesBase.name,
  """
    Resource name for a given resource provider. For example:
    - SKU name for Microsoft.Compute
    - SKU or TotalLowPriorityCores for Microsoft.MachineLearningServices
     For Microsoft.Network PublicIPAddresses.
    """
);
@@doc(CurrentUsagesBase.properties,
  "Usage properties for the specified resource."
);
