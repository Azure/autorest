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
 * Describes a cloud service OS version.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
model OSVersion {
  ...ResourceNameParameter<
    Resource = OSVersion,
    KeyName = "osVersionName",
    SegmentName = "cloudServiceOsVersions",
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
   * OS version properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: OSVersionProperties;
}

@armResourceOperations
interface OSVersions {
  /**
   * Gets properties of a guest operating system version that can be specified in the XML service configuration (.cscfg) for a cloud service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceOperatingSystems_GetOSVersion")
  getOSVersion is ArmResourceRead<OSVersion>;

  /**
   * Gets a list of all guest operating system versions available to be specified in the XML service configuration (.cscfg) for a cloud service. Use nextLink property in the response to get the next page of OS versions. Do this till nextLink is null to fetch all the OS versions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceOperatingSystems_ListOSVersions")
  listOSVersions is ArmResourceListByParent<OSVersion>;
}

@@doc(OSVersion.name, "Name of the OS version.");
