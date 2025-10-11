import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GroupQuotasEntity.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Quota;
/** Status of a single GroupQuota request. */
@parentResource(GroupQuotasEntity)
model SubmittedResourceRequestStatus
  is Azure.ResourceManager.ProxyResource<SubmittedResourceRequestStatusProperties> {
  ...ResourceNameParameter<
    Resource = SubmittedResourceRequestStatus,
    KeyName = "requestId",
    SegmentName = "groupQuotaRequests",
    NamePattern = ""
  >;
}

@armResourceOperations
interface SubmittedResourceRequestStatuses {
  /** Get API to check the status of a GroupQuota request by requestId. */
  get is Extension.Read<
    Extension.ManagementGroup,
    SubmittedResourceRequestStatus
  >;
}

@@doc(SubmittedResourceRequestStatus.name, "Request Id.");
@@doc(SubmittedResourceRequestStatus.properties, "");
