import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
// FIXME: CommunityGallery has no properties property
/**
 * Specifies information about the Community Gallery that you want to create or update.
 */
@subscriptionResource
@parentResource(SubscriptionLocationResource)
model CommunityGallery is Azure.ResourceManager.ProxyResource<{}> {
  ...ResourceNameParameter<
    Resource = CommunityGallery,
    KeyName = "publicGalleryName",
    SegmentName = "communityGalleries",
    NamePattern = ""
  >;
}

@armResourceOperations
interface CommunityGalleries {
  /**
   * Get a community gallery by gallery public name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("CommunityGalleries_Get")
  get is ArmResourceRead<
    CommunityGallery,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}

@@doc(CommunityGallery.name, "The public name of the community gallery.");
