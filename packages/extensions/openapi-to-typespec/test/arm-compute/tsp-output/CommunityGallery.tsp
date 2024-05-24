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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
model CommunityGallery extends PirCommunityGalleryResource {
  ...ResourceNameParameter<
    Resource = CommunityGallery,
    KeyName = "publicGalleryName",
    SegmentName = "communityGalleries",
    NamePattern = ""
  >;

  @extension("x-ms-client-flatten", true)
  @visibility("read,create")
  properties?: {};
}

@armResourceOperations
interface CommunityGalleries {
  /**
   * Get a community gallery by gallery public name.
   */
  get is ArmResourceRead<CommunityGallery>;
}

@@doc(CommunityGallery.name, "The public name of the community gallery.");
