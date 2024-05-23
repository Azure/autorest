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
/**
 * Describes a cloud service OS family.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
model OSFamily {
  ...ResourceNameParameter<
    Resource = OSFamily,
    KeyName = "osFamilyName",
    SegmentName = "cloudServiceOsFamilies",
    NamePattern = ""
  >;

  /**
   * Resource Id.
   */
  @visibility("read")
  id?: string;

  /**
   * Resource type.
   */
  @visibility("read")
  type?: string;

  /**
   * Resource location.
   */
  @visibility("read")
  location?: string;

  /**
   * OS family properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: OSFamilyProperties;
}

@armResourceOperations
interface OSFamilies {
  /**
   * Gets properties of a guest operating system family that can be specified in the XML service configuration (.cscfg) for a cloud service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceOperatingSystems_GetOSFamily")
  getOSFamily is ArmResourceRead<OSFamily>;

  /**
   * Gets a list of all guest operating system families available to be specified in the XML service configuration (.cscfg) for a cloud service. Use nextLink property in the response to get the next page of OS Families. Do this till nextLink is null to fetch all the OS Families.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceOperatingSystems_ListOSFamilies")
  listOSFamilies is ArmResourceListByParent<OSFamily>;
}

@@doc(OSFamily.name, "Name of the OS family.");
