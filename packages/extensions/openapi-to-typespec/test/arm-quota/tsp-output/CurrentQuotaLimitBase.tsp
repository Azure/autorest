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
 * Quota limit.
 */
@extensionResource
model CurrentQuotaLimitBase
  is Azure.ResourceManager.ExtensionResource<QuotaProperties> {
  ...ResourceNameParameter<
    Resource = CurrentQuotaLimitBase,
    KeyName = "resourceName",
    SegmentName = "quotas",
    NamePattern = ""
  >;
}

@armResourceOperations
interface CurrentQuotaLimitBases {
  /**
   * Get the quota limit of a resource. The response can be used to determine the remaining quota to calculate a new quota limit that can be submitted with a PUT request.
   */
  get is Extension.Read<Extension.ScopeParameter, CurrentQuotaLimitBase>;

  /**
   * Create or update the quota limit for the specified resource with the requested value. To update the quota, follow these steps:
   * 1. Use the GET operation for quotas and usages to determine how much quota remains for the specific resource and to calculate the new quota limit. These steps are detailed in [this example](https://techcommunity.microsoft.com/t5/azure-governance-and-management/using-the-new-quota-rest-api/ba-p/2183670).
   * 2. Use this PUT operation to update the quota limit. Please check the URI in location header for the detailed status of the request.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is Extension.CreateOrReplaceAsync<
    Extension.ScopeParameter,
    CurrentQuotaLimitBase,
    Response = ArmResourceUpdatedResponse<CurrentQuotaLimitBase> | ArmAcceptedLroResponse
  >;

  /**
   * Update the quota limit for a specific resource to the specified value:
   * 1. Use the Usages-GET and Quota-GET operations to determine the remaining quota for the specific resource and to calculate the new quota limit. These steps are detailed in [this example](https://techcommunity.microsoft.com/t5/azure-governance-and-management/using-the-new-quota-rest-api/ba-p/2183670).
   * 2. Use this PUT operation to update the quota limit. Please check the URI in location header for the detailed status of the request.
   */
  @patch(#{ implicitOptionality: false })
  update is Extension.CustomPatchAsync<
    Extension.ScopeParameter,
    CurrentQuotaLimitBase,
    PatchModel = CurrentQuotaLimitBase
  >;

  /**
   * Get a list of current quota limits of all resources for the specified scope. The response from this GET operation can be leveraged to submit requests to update a quota.
   */
  list is Extension.ListByTarget<
    Extension.ScopeParameter,
    CurrentQuotaLimitBase,
    Response = ArmResponse<QuotaLimits>
  >;
}

@@doc(CurrentQuotaLimitBase.name,
  """
    Resource name for a given resource provider. For example:
    - SKU name for Microsoft.Compute
    - SKU or TotalLowPriorityCores for Microsoft.MachineLearningServices
     For Microsoft.Network PublicIPAddresses.
    """
);
@@doc(CurrentQuotaLimitBase.properties,
  "Quota properties for the specified resource, based on the API called, Quotas or Usages."
);
@@doc(CurrentQuotaLimitBases.createOrUpdate::parameters.resource,
  "Quota request payload."
);
@@doc(CurrentQuotaLimitBases.update::parameters.properties,
  "Quota requests payload."
);
