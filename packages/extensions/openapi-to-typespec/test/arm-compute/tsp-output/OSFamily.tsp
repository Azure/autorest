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
@subscriptionResource
model OSFamily is Azure.ResourceManager.ProxyResource<OSFamilyProperties> {
  ...ResourceNameParameter<
    Resource = OSFamily,
    KeyName = "osFamilyName",
    SegmentName = "cloudServiceOsFamilies",
    NamePattern = ""
  >;

  /**
   * Resource location.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  @visibility(Lifecycle.Read)
  location?: string;
}

@armResourceOperations
interface OSFamilies {
  /**
   * Gets properties of a guest operating system family that can be specified in the XML service configuration (.cscfg) for a cloud service.
   */
  getOSFamily is ArmResourceRead<
    OSFamily,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * Gets a list of all guest operating system families available to be specified in the XML service configuration (.cscfg) for a cloud service. Use nextLink property in the response to get the next page of OS Families. Do this till nextLink is null to fetch all the OS Families.
   */
  listOSFamilies is ArmResourceListByParent<
    OSFamily,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;
}

@@doc(OSFamily.name, "Name of the OS family.");
@@doc(OSFamily.properties, "OS family properties.");
