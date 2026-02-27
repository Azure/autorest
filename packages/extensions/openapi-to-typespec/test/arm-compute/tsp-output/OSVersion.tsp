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
/** Describes a cloud service OS version. */
@subscriptionResource
model OSVersion is Azure.ResourceManager.ProxyResource<OSVersionProperties> {
  ...ResourceNameParameter<
    Resource = OSVersion,
    KeyName = "osVersionName",
    SegmentName = "cloudServiceOsVersions",
    NamePattern = ""
  >;

  /** Resource location. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  location?: string;
}

@armResourceOperations
interface OSVersions {
  /** Gets properties of a guest operating system version that can be specified in the XML service configuration (.cscfg) for a cloud service. */
  getOSVersion is ArmResourceRead<
    OSVersion,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /** Gets a list of all guest operating system versions available to be specified in the XML service configuration (.cscfg) for a cloud service. Use nextLink property in the response to get the next page of OS versions. Do this till nextLink is null to fetch all the OS versions. */
  listOSVersions is ArmResourceListByParent<
    OSVersion,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}

@@doc(OSVersion.name, "Name of the OS version.");
@@doc(OSVersion.properties, "OS version properties.");
